import 'dart:convert';

import 'package:apicacion_ia/env.dart';
import 'package:apicacion_ia/response/reponse_result.dart';
import 'package:apicacion_ia/response/request_text_image.dart';
import 'package:apicacion_ia/response/response_generic_data.dart';
import 'package:apicacion_ia/response/response_image_entity.dart';
import 'package:either_dart/either.dart';
import 'package:http/http.dart' as http;
import "package:uuid/uuid.dart";

String imageIdGenerator() {
  return const Uuid().v1();
}

class ApiImageRepositoryImpl {
  Future<Either<ResponseResult, ResponseGenericData<ResponseImageEntity>>>
      createTextImage({
    required RequestTextImage requestTextImage,
  }) async {
    try {
      final url = Uri.parse('${Env.urlServerReplicate}/v1/predictions');
      final headers = {
        'Authorization': 'Bearer ${Env.tokenAIReplicate}',
        'Content-Type': 'application/json',
      };
      final body = jsonEncode({
        "version":
            "5f24084160c9089501c1b3545d9be3c27883ae2239b6f412990e82d4a6210f8f",
        "input": {
          "seed": 2992471961,
          "width": 832,
          "height": 832,
          "prompt": requestTextImage.prompt,
          "scheduler": requestTextImage.scheduler,
          "num_outputs": 1,
          "guidance_scale": 0,
          "negative_prompt": requestTextImage.negativePrompt,
          "num_inference_steps": 4
        }
      });

      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode >= 200 && response.statusCode <= 220) {
        ResponseImageEntity? responseImageEntity;
        do {
          final uriResult = Uri.parse(
            "${Env.urlServerReplicate}/v1/predictions/${jsonDecode(response.body)["id"]}",
          );
          final jsonResult = await http.get(
            uriResult,
            headers: headers,
          );

          responseImageEntity = responseImageEntityFromJson(
            jsonEncode(
              [
                {
                  "created_at": jsonDecode(jsonResult.body)["created_at"],
                  "error": jsonDecode(jsonResult.body)["error"],
                  "id": jsonDecode(jsonResult.body)["id"],
                  "output": jsonDecode(jsonResult.body)["output"] != null
                      ? [...jsonDecode(jsonResult.body)["output"]]
                      : [],
                  "status": jsonDecode(jsonResult.body)["status"],
                  "uuid": imageIdGenerator(),
                }
              ],
            ),
          ).first;
        } while (responseImageEntity.status == "starting" ||
            responseImageEntity.status == "processing");

        if (responseImageEntity.error != null) {
          throw UnimplementedError(responseImageEntity.error.toString());
        }
        return Right(
          ResponseGenericData(
            responseResult: ResponseResult(
              responseStatus: ResponseStatus.success,
              message: "Proceso exitoso",
            ),
            data: responseImageEntity,
          ),
        );
      } else {
        throw UnimplementedError();
      }
    } catch (e) {
      return Left(
        ResponseResult(
          responseStatus: ResponseStatus.error,
          message: e.toString(),
        ),
      );
    }
  }
}

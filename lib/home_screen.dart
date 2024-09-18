import 'package:apicacion_ia/repository.dart';
import 'package:apicacion_ia/response/reponse_result.dart';
import 'package:apicacion_ia/response/request_text_image.dart';
import 'package:apicacion_ia/response/response_image_entity.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ResponseResult responseResult;

  List<ResponseImageEntity> responseImageList = [];

  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    responseResult = ResponseResult(
      responseStatus: ResponseStatus.off,
      message: "",
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: textEditingController,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              setState(
                () {
                  responseResult = ResponseResult(
                    responseStatus: ResponseStatus.loading,
                    message: "loading",
                  );
                },
              );
              final response = ApiImageRepositoryImpl();
              final responseImage = await response.createTextImage(
                requestTextImage: RequestTextImage(
                  prompt: textEditingController.text,
                  negativePrompt: "",
                  scheduler: "DPMSolverMultistep",
                ),
              );

              responseImage.either(
                (error) {
                  responseResult = error;
                  setState(() {});
                },
                (success) {
                  responseResult = success.responseResult;
                  responseImageList.add(
                    success.data!,
                  );
                  setState(() {});
                },
              );
            },
            child: const Text(
              "Generar",
            ),
          ),
          const SizedBox(height: 20),
          if (responseResult.responseStatus == ResponseStatus.loading)
            const Center(child: CircularProgressIndicator()),
          if (responseResult.responseStatus == ResponseStatus.error)
            Text(responseResult.message),
          Expanded(
              child: ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(
              height: 10,
            ),
            itemCount: responseImageList.length,
            itemBuilder: (context, index) {
              final item = responseImageList[index];
              return Image.network(
                item.output!.first,
                height: 200,
              );
            },
          )),
        ],
      ),
    );
  }
}

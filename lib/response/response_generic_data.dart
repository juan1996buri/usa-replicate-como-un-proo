import 'package:apicacion_ia/response/reponse_result.dart';

class ResponseGenericData<T> {
  final ResponseResult responseResult;
  final T? data;

  const ResponseGenericData({
    required this.responseResult,
    required this.data,
  });
}

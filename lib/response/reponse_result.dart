class ResponseResult {
  final ResponseStatus responseStatus;
  final String message;

  ResponseResult({
    required this.responseStatus,
    required this.message,
  });
}

enum ResponseStatus {
  success,
  off,
  error,
  loading,
  notFound,
  successFile,
  loadingFile,
  loadingShare
}

sealed class BaseResponse<T> {
  const BaseResponse();
}

class SuccessResponse<T> extends BaseResponse<T> {
  final T data;

  const SuccessResponse({required this.data});
}

class ErrorResponse<T> extends BaseResponse<T> {
  final String errorMessage;
  const ErrorResponse({required this.errorMessage});
}


import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:fitness_app/core/errors/handel_errors.dart';

mixin ApiExecutionMixin {
  Future<BaseResponse<T>> execute<D, T>({
    required Future<D> Function() action,
    required T Function(D data) mapper,
  }) async {
    try {
      final response = await action();
      return SuccessResponse(data: mapper(response));
    } catch (e) {
      final errorMessage = ErrorHandler.handleError(e);
      return ErrorResponse(errorMessage: errorMessage);
    }
  }
}

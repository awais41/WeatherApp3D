import 'result.dart';
import '../errors/failures.dart';

class Success<T> extends Result<T> {
  final T data;

  const Success(this.data);

  @override
  R fold<R>(
    R Function(Failure failure) onFailure,
    R Function(T data) onSuccess,
  ) {
    return onSuccess(data);
  }
}

import '../errors/failures.dart';

export 'failure_result.dart';
export 'success.dart';

abstract class Result<T> {
  const Result();

  R fold<R>(
    R Function(Failure failure) onFailure,
    R Function(T data) onSuccess,
  );
}

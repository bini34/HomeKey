import 'package:dartz/dartz.dart';
import '../error/failures.dart';

// Abstract base class for use cases in the domain layer.
// Defines a contract for use cases to return an Either<Failure, Type> result, promoting functional programming.
// Type is the return type, Params is the input type (can be void for no parameters).
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class Params<T> {
  final T data;

  Params(this.data);
}

class NoParams {
  NoParams();
}
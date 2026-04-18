import 'package:dartz/dartz.dart';
import 'package:product_browser_app/core/errors/failures.dart';

abstract class UseCase<T, Param> {
  Future<Either<Failure, T>> call(Param param);
}

class NoParam {}
import 'package:dartz/dartz.dart';

extension EitherExtension<L, R> on Either<L, R> {
  R? get rightOrNull => fold((_) => null, (right) => right);
  L? get leftOrNull => fold((left) => left, (_) => null);
}

abstract class SynchronousUseCase<Type, Params> {
  Type call(Params params);
}
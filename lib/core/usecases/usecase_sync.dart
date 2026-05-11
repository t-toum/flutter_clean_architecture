abstract class SynchronousUseCase<Result, Params> {
  Result call(Params params);
}
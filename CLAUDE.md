# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Install dependencies
flutter pub get

# Generate code (run after modifying annotated files)
dart run build_runner build --delete-conflicting-outputs

# Watch mode for code generation during development
dart run build_runner watch --delete-conflicting-outputs

# Run the app
flutter run

# Run all tests
flutter test

# Run a single test file
flutter test test/widget_test.dart

# Lint
flutter analyze
```

## Architecture

This project implements **Clean Architecture** with a feature-based folder structure under `lib/features/`. Each feature is divided into three layers:

```
features/<feature>/
├── domain/          # Pure Dart — no Flutter/framework dependencies
│   ├── entities/    # Core business objects (extend Equatable)
│   ├── repositories/# Abstract interfaces returning Either<Failure, T>
│   └── usecases/   # One use case per file; extend UseCase<Result, Params>
├── data/
│   ├── models/      # Extend domain entities; add JSON serialization (@JsonSerializable)
│   ├── datasources/ # Remote (Retrofit) and local (SharedPreferences) sources
│   └── repositories/# Concrete implementations; catch exceptions, return Failures
└── presentation/
    ├── cubit/       # flutter_bloc Cubits with Freezed state classes
    └── pages/       # UI; use BlocBuilder/BlocListener against Cubit states
```

### Error handling pattern

- **Datasources** throw `ServerException` / `CacheException`
- **Repository implementations** catch those and return `Left(ServerFailure())` / `Left(CacheFailure())`
- **Cubits** fold the `Either` and emit the appropriate `DataStatus` (initial / loading / success / failure)
- `Either` comes from `dartz`; use the `EitherExtension` helpers in `core/extension/either_extension.dart`

### Dependency injection

- `GetIt` + `injectable` annotations drive all DI.
- Annotate classes with `@lazySingleton`, `@injectable`, etc.
- Singletons that need async setup (e.g., `SharedPreferences`) are registered as `@preResolvedSingleton` in `core/DI/register_modules.dart`.
- After changing DI annotations, re-run `build_runner` — the generated file is `core/DI/service_locator.config.dart`.
- Access the locator via `getIt<T>()` exported from `core/DI/service_locator.dart`.

### Networking

- `RestClient` (`core/network/rest_client.dart`) is a Retrofit client over Dio with a 10 s connect / 20 s receive timeout.
- Base URL is `https://jsonplaceholder.typicode.com` (defined in `core/constants/api_path.dart`).
- Add new endpoints to `RestClient`, then run `build_runner` to regenerate `rest_client.g.dart`.

### Routing

- `GoRouter` is configured in `core/routers/app_router.dart`.
- Each route wraps its page in the required `BlocProvider`(s) and triggers initial data loading there rather than inside the page's `initState`.

### Localization

- Uses `easy_localization` with translations loaded remotely from S3 and cached in `SharedPreferences` via `RemoteAssetLoader` (`core/services/remote_asset_loader.dart`).
- Localization keys are typed constants in `core/constants/locale_keys.dart`.

## Code generation

The following annotations require `build_runner`:

| Annotation / library | Output file suffix |
|---|---|
| `@JsonSerializable` (json_serializable) | `.g.dart` |
| `@RestApi` (retrofit) | `.g.dart` |
| `@freezed` (freezed) | `.freezed.dart` |
| `@injectable` / `@injectableInit` | `service_locator.config.dart` |

Always commit generated files alongside the source files that produce them.

# Flutter Clean Architecture

A Flutter starter template implementing Clean Architecture with a feature-based folder structure, functional error handling, code generation, and remote localization.

## Tech Stack

| Concern | Library |
|---|---|
| State management | flutter_bloc |
| Immutable state | freezed |
| Dependency injection | get_it + injectable |
| Functional error handling | dartz (`Either<Failure, T>`) |
| HTTP client | dio + retrofit |
| Routing | go_router |
| Localization | easy_localization |
| Local storage | shared_preferences |
| JSON serialization | json_serializable |

## Getting Started

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

## Project Structure

```
lib/
├── core/
│   ├── DI/              # GetIt service locator & injectable configuration
│   ├── constants/       # API paths, locale keys, enums
│   ├── errors/          # Failures and exceptions
│   ├── extension/       # Either extensions
│   ├── network/         # Retrofit REST client
│   ├── routers/         # GoRouter configuration
│   ├── services/        # Remote asset loader (localization)
│   ├── usecases/        # Base UseCase abstractions
│   └── widgets/         # Shared widgets
└── features/
    └── <feature>/
        ├── domain/      # Entities, repository interfaces, use cases
        ├── data/        # Models, datasources, repository implementations
        └── presentation/# Cubits, pages
```

## Architecture

Each feature follows a strict three-layer separation:

**Domain** — pure Dart, no framework dependencies. Defines entities, abstract repository contracts returning `Either<Failure, T>`, and use cases.

**Data** — implements domain contracts. Models extend entities and add JSON serialization. Datasources (remote/local) throw typed exceptions. Repository implementations catch exceptions and return `Left(Failure)`.

**Presentation** — Cubits hold `DataStatus` state (initial / loading / success / failure) built with Freezed. Pages use `BlocBuilder`/`BlocListener` against Cubit states.

### Error flow

```
DataSource (throws Exception)
  → Repository (catches → Left(Failure))
    → UseCase (passes Either through)
      → Cubit (folds Either → emits state)
```

## Code Generation

Re-run after modifying any annotated file:

```bash
dart run build_runner build --delete-conflicting-outputs
# or watch mode during development
dart run build_runner watch --delete-conflicting-outputs
```

| Source annotation | Generated file |
|---|---|
| `@JsonSerializable` | `*.g.dart` |
| `@RestApi` (Retrofit) | `rest_client.g.dart` |
| `@freezed` | `*.freezed.dart` |
| `@injectable` / `@injectableInit` | `service_locator.config.dart` |

## Adding a New Feature

1. Create `lib/features/<name>/domain/entities/`, `repositories/`, `usecases/`
2. Create `lib/features/<name>/data/models/`, `datasources/`, `repositories/`
3. Create `lib/features/<name>/presentation/cubit/` and `pages/`
4. Register datasource and repository in the DI module (or annotate with `@lazySingleton`)
5. Add a route in `core/routers/app_router.dart`
6. Run `build_runner`

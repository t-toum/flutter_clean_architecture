# Flutter Clean Architecture

A Flutter starter project that demonstrates a clean architecture setup with feature-based modules, dependency injection, typed API clients, Bloc/Cubit state management, routing, localization, and functional error handling.

The sample `home` feature fetches todos from [JSONPlaceholder](https://jsonplaceholder.typicode.com) and renders them in a simple list.

## Tech Stack

- Dart SDK `^3.9.2` with Flutter
- `flutter_bloc` for presentation state management
- `get_it` and `injectable` for dependency injection
- `dio` and `retrofit` for HTTP networking
- `dartz` for `Either`-based success/failure handling
- `freezed` for immutable state classes
- `json_serializable` for model serialization
- `go_router` for navigation
- `easy_localization` for localization
- `shared_preferences` for local persistence wiring

## Project Structure

```text
lib/
  main.dart
  core/
    DI/             # service locator and injectable modules
    client/         # Retrofit REST client
    constants/      # API paths, locale keys, enums
    errors/         # exceptions and failures
    extension/      # helper extensions
    routers/        # GoRouter configuration
    services/       # app services such as remote localization loading
    usecases/       # base use case contracts
    widgets/        # shared widgets
  features/
    home/
      data/         # data sources, models, repository implementation
      domain/       # entities, repository contracts, use cases
      presentation/ # Cubit, state, and UI page
```

## Architecture

This project follows a three-layer feature structure:

- `presentation`: UI widgets and Cubit state management.
- `domain`: business entities, repository contracts, and use cases.
- `data`: API models, remote/local data sources, and repository implementations.

Shared concerns live under `lib/core`, including dependency injection, routing, API client configuration, error types, and base use case contracts.

The current todo flow is:

```text
HomePage
  -> HomeCubit
  -> GetTodoUseCase
  -> HomeRepository
  -> HomeRepositoryImpl
  -> HomeRemoteDataSource
  -> RestClient
  -> https://jsonplaceholder.typicode.com/todos
```

## Getting Started

### Prerequisites

- Flutter SDK installed
- A working iOS, Android, web, desktop, or simulator target

Check your local setup:

```sh
flutter doctor
```

### Install Dependencies

```sh
flutter pub get
```

### Generate Code

This project uses code generation for Injectable, Retrofit, Freezed, and JSON serialization.

Run:

```sh
dart run build_runner build --delete-conflicting-outputs
```

Generated files are intended to be committed. Regenerate them whenever annotations, models, routes, services, or dependency registrations change.

Generated files include:

- `lib/core/DI/service_locator.config.dart`
- `lib/core/client/rest_client.g.dart`
- `lib/features/home/data/models/todo_model.g.dart`
- Freezed state output such as `home_cubit.freezed.dart`

### Run the App

```sh
flutter run
```

Run on a specific target:

```sh
flutter devices
flutter run -d chrome
flutter run -d ios
flutter run -d android
```

## Localization

The app is configured with `easy_localization` and supports:

- English: `en_US`
- Lao: `lo_LA`

Localization files are loaded remotely through `LocaleAssetLoader` from:

```text
https://ezlocalization.s3.ap-southeast-1.amazonaws.com/i18n
```

Local translation assets are currently disabled in `pubspec.yaml`. If you want bundled fallback translations, uncomment the assets section and add JSON files under `assets/translations/`.

## API Configuration

The base API URL is defined in:

```text
lib/core/constants/api_path.dart
```

Current value:

```dart
static const String baseUrl = "https://jsonplaceholder.typicode.com";
```

The todo endpoint is declared in:

```text
lib/core/client/rest_client.dart
```

## Useful Commands

Analyze the project:

```sh
flutter analyze
```

Run tests:

```sh
flutter test
```

Format Dart files:

```sh
dart format .
```

Regenerate source files after changing annotations:

```sh
dart run build_runner build --delete-conflicting-outputs
```

Watch code generation during development:

```sh
dart run build_runner watch --delete-conflicting-outputs
```

## Notes

- The widget test verifies that the home page renders todos using a fake repository.
- Generated files should be refreshed whenever Retrofit, Injectable, Freezed, or JSON annotations change.
- The app requires network access to fetch todos and remote localization files.

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.

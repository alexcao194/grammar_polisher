# grammar_polisher

Refine your writing with step-by-step grammar guidance.

## Required Environment

### Framework
- [Flutter SDK >= 3.27.0](https://flutter.dev/docs/get-started/install)
- [Dart SDK >= 3.6.0](https://dart.dev/get-dart)

### Android
- [Android Studio >= Ladybug](https://developer.android.com/studio)
- [Android SDK](https://developer.android.com/studio)

### iOS
- [Xcode >= 15.0](https://developer.apple.com/xcode/)
- [Cocoapods >= 1.16.2](https://cocoapods.org)

## Should Have Android Studio Plugins
- Flutter
- Dart
- FlutterAssetsGenerator
- Bloc

## Folder structure
- `assets`: The folder to store resources file such as fonts, images and lottie animations
    - `images`: store images
    - `sounds`: store sounds
    - `fonts`: store fonts
- `lib`: The folder is main container of all code inside Zeniuz application
    - `configs`: Configuration of Router, Supabase, etc.
    - `constants`: Constants of application
    - `core`: Base classes, extensions, etc.
    - `data`: 
        - `data_sources`: Data sources such as API, Database, realtime, etc.
        - `models`: Data models convert from raw data to entity
        - `repositories`: Repositories to interact with data sources
    - `gererared`: Generated files (intl, assets, etc.)
    - `navigation`: Navigation of application
    - `ui`: User interface
        - `commons`: Common and base widgets
        - `screens`: 
            - `home`:
                - `bloc`: Join screen bloc
                - `widgets`: Widgets of Join screen
                - `home_screen.dart`: Join screen
    - `utils`: Helper functions
    - `main.dart`: Entry point of application
    - `app.dart`: Wrapper of application

## Code style
- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart/style)
- Import from dart package first, then flutter package, then project package, then current package
- Importing from the same package should be in one line and use relative path
    - ex: `import '../../models/user_model.dart'`

## Usage

### Install dependencies
- Move to root dir `cd {root}`
- Install necessary packages `flutter pub get`

### Generate files
- Generate necessary files: `flutter pub run build_runner build --delete-conflicting-outputs`
- Click `Build` -> `Generate Flutter Assets` to generate assets path
- Note: If you create a new assets folder, right-click on the folder and click `Flutter: Configuring Paths` to add assets path into `pubspec.yaml`

### Run
- We have 2 flavors: `development` and `production`
- Get the environment file from [alexcao194](https://github.com/alexcao194) and put it in `.env/` folder, that named `development.json`
- Run `flutter run --flavor development --dart-define-from-file=.env/development.json` to run the app in development mode
- We don't need to run the app in production mode, because we will build the app for production

### Sign with your own keystore
- Create a keystore file `keystore.jks`, it should be placed in `android/app` folder
- Create a file `key.properties` in `android` folder with the following content:

```
storePassword=<password>
keyPassword=<password>
keyAlias=<alias>
storeFile=<relative path to keystore file> (from android/app)
```

### Build
- Android: `flutter build (apk|aab) --flavor development --dart-define-from-file=.env/development.json`
- IOS: `flutter build ios --flavor development --dart-define-from-file=.env/development.json`

And That's it! You are ready to go! 🚀

## Contributing
- Clone the repository
- See [CONTRIBUTION.md](CONTRIBUTION.md) for more details
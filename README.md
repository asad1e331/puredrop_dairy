# PureDrop Dairy

I built this Flutter app for my Ezitech internship. The dashboard shows seven days of sample milk deliveries, including the date, quantity, and delivery status.

## How the app works

The domain layer defines the `Delivery` model and the repository contract. The data layer handles the mock API and the Hive cache. The presentation layer displays the delivery list and handles loading, empty, and error states.

When the app fetches deliveries, the repository saves them in Hive. The dashboard watches a Riverpod stream, so the list updates when the cache changes. If the device loses its network connection, the app shows an offline banner and keeps the saved deliveries visible. When the connection returns, the app refreshes automatically.

See the [Technical Decision Log](DECISIONS.md) for why I chose Riverpod over Provider or BLoC for this project.

## Run on Android

Install Flutter and the Android SDK. Connect an Android phone with USB debugging enabled or start an emulator. Then run these commands from the project folder.


flutter pub get
flutter run


## Run tests


flutter analyze
flutter test

The tests cover valid, missing, and invalid values in `Delivery` and `Message` records. They also check that Hive records survive closing and reopening the box and that the dashboard updates when the delivery stream changes.

### Check offline behavior

1. Open the app while connected and wait for the deliveries to load.
2. Close the app completely, turn off Wi-Fi and mobile data, and open it again.
3. Check that the saved deliveries and the **You're Offline** banner appear.
4. Reconnect and check that the banner disappears.

## Build and install the APK


flutter build apk --release


The APK is saved at `build/app/outputs/flutter-apk/app-release.apk`. With an Android device connected over USB, install it using:


adb install -r build/app/outputs/flutter-apk/app-release.apk


The current Gradle setup uses a debug signing key for this test APK. Client distribution requires a client-owned release key.

## Current scope

Deliveries and subscription details use sample data. The Hive cache is unencrypted and stores sample deliveries. The `Message` model has parsing tests. Live support chat is still pending.

## Author

Asad Bajwa  

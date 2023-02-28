# APP2

## Short description

- The application can be built for Android and iOS
- It is ready for about 90%, at least needs some work on Rounds/Routine feature
- It communicates with DB using new API, integrated to web2 project
- Unlike app1, it is designed to be used for different customers with a single build

## Requirements

- Flutter SDK
- Android SDK (to build for Android)
- XCode on Mac (to build for iOS)
- Android Studio or VSCode

## Run steps

The sources do not need any preparations or configuring.
Just use the usual steps to build/debug flutter mobile app, it can be like the following for Android:

1. open in Android Studio or VSCode, make sure your IDE can see Flutter SDK and Android SDK
2. execute at the root of the project (or use IDE's helpers for it): flutter pub get
3. select your Android device (physical or emulated one) in IDE
4. Run debugging or build release apk

## Device registration

Since app2 can be used for a few customers by a single build, it requires first-run device registration.
The user should input "System id" and "password".
"System id" - customer name, as in domain name
"password" - assigned at web2 > Settings > Devices (do not forget to allow unknow devices there as well)

Admin can manage registered devices via a list of devices in web: Adminstartion > Devices

## Customization

All possible customizations are available at web2 > Settings > App

# LifeSync iOS Google sign-in

Firebase project: `lifesync-59495`. Registered Apple bundle ID:
`com.genzbuilder.lifesync`. Google provider is shared with the existing Android
app. Flutter now allows Google authentication on iOS and exchanges the Firebase
ID token with the existing `/api/auth/google` backend; no authentication bypass.

The iOS client ID and reversed URL scheme are in Runner/Info.plist. The downloaded
GoogleService-Info.plist is referenced in Runner's Copy Bundle Resources. It is
ignored by Git, so transfer it separately to the Mac or download it from Firebase
project settings → LifeSync iOS. Do not use the Android JSON or a service-account
key. Place it at `ios/Runner/GoogleService-Info.plist` with that exact filename.

## On your Mac

Use an up-to-date Flutter SDK and Xcode compatible with the locked Firebase
plugins. The project uses Swift Package Manager and targets iOS 15 or newer.
From the `life_sync_app` directory:

```sh
flutter pub get
open ios/Runner.xcworkspace
```

In Xcode select Runner → Signing & Capabilities, select your own Apple development
Team, and enable automatic signing. Keep the bundle ID above. No team or signing
certificate has been fabricated or installed. Connect/unlock your iPhone, trust
the Mac, and enable Developer Mode if required by iOS. Then:

```sh
flutter devices
flutter run -d YOUR_IPHONE_DEVICE_ID --dart-define=API_BASE_URL=https://lifesync-backend-bultoncr7-dev.apps.rm3.7wse.p1.openshiftapps.com
```

Test Continue with Google, cancel, successful account selection, profile
completion, Home navigation, app restart/session restoration and logout. Also
test profile-photo selection and upload. Android-only local notification delivery
is not made iOS-compatible by this sign-in change.

If Xcode reports package-resolution problems, let Flutter regenerate its ephemeral
Swift package with `flutter pub get` and retry package resolution in Xcode. Do not
copy Windows-generated ephemeral files to the Mac.

## Verification limit

Firebase iOS registration and downloaded bundle/project IDs were verified here.
Windows cannot compile, sign, or test the iOS binary. A passing Dart suite is not
proof of iPhone Google sign-in. No IPA or App Store release is claimed.

References:
- https://pub.dev/packages/google_sign_in_ios
- https://firebase.google.com/docs/ios/setup

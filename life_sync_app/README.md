# LifeSync mobile app

## API configuration

The mobile client defaults to the OpenShift HTTPS origin in `AppEnvironment.defaultApiBaseUrl` on physical devices, emulators, and release builds. `flutter run` uses that shared default. Explicit compile-time `API_BASE_URL` (or legacy `LIFE_SYNC_API_BASE_URL`) defines override it. The API value is an **origin only**; do not append `/api`, because feature requests already use paths such as `/api/auth/login`. VS Code launch configurations intentionally do not load a potentially stale `.env`.

For local Android emulator development:

```bash
flutter run --dart-define=API_BASE_URL=http://localhost:8085 \
  --dart-define=ANDROID_USE_EMULATOR_ALIAS=true
```

The emulator flag maps `http://localhost:8085` to `http://10.0.2.2:8085`. It is deliberately opt-in so a physical device cannot silently use the emulator-only alias.

For a physical Android device, provide a host LAN address reachable from the phone (with the backend firewall port open) or an HTTPS deployment origin:

```bash
flutter run -d <device-id> \
  --dart-define=API_BASE_URL=http://<host-lan-ip>:8085
```

Do not use `10.0.2.2` on a physical device.

For a production APK, provide the OpenShift HTTPS route at build time and do not commit `.env` or secrets:

```bash
flutter build apk --release \
  --dart-define=API_BASE_URL=https://<production-api-origin>
```

For a temporary troubleshooting build, diagnostics can be explicitly enabled. They log only method, path, status, and Dio failure type; they never log headers, credentials, or bodies:

```bash
flutter build apk --release \
  --dart-define=API_BASE_URL=https://<production-api-origin> \
  --dart-define=API_DIAGNOSTICS=true
```

Release builds default to OpenShift and require HTTPS for overrides. Updating a compile-time URL or Dart source requires rebuilding and installing the app; an already installed APK does not update itself. The Android package is now `com.genzbuilder.lifesync`. An older `com.example.life_sync_app` installation is a separate app and may still have the same launcher label. Open the newly installed app; do not clear or uninstall the old one unless its local data is no longer needed.

## Verification

```bash
flutter pub get
flutter analyze
flutter test
```

Route availability and physical-device connectivity must still be verified separately. Changing the client URL cannot wake a stopped OpenShift Sandbox deployment.

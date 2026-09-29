# LifeSync production release gates

Status: not approved for public production release. A completion percentage is
not a release criterion. Existing local modifications are preserved.

Owner decision: direct APK distribution, no Play Store for now, free hosting only.
For an explicitly development-signed APK compatible with the installed test app:

```powershell
$env:LIFESYNC_ALLOW_TEST_SIGNING='true'
flutter build apk --release --dart-define=API_BASE_URL=https://lifesync-backend-bultoncr7-dev.apps.rm3.7wse.p1.openshiftapps.com
Remove-Item Env:LIFESYNC_ALLOW_TEST_SIGNING
```

Run from `life_sync_app`. This is a test-distribution override, not production
signing or an uptime guarantee. Do not enable it in a production build pipeline.

## Verified before this audit

- Flutter analysis clean and 116 automated tests passed.
- Samsung native integration tests observed immediate and scheduled notifications,
  cancellation, and HTTPS backend health. This does not prove all real-account flows.
- Local task reminders and seven-day habit schedules exist. Remote push and
  historical missed-habit alerts do not.

## Required before release

| Gate | Status / evidence needed |
| --- | --- |
| Android signing | Blocked: owner-controlled production keystore not configured. Debug signing fallback removed. |
| Google sign-in | Register the production signing certificate in Firebase and test the signed build. For Play distribution also register the Play app-signing certificate. |
| Hosting | Owner must choose hosting acceptable for production availability. Do not promise continuous uptime from a development environment. |
| Push delivery | Implement device-token registration, authenticated ownership, token removal on logout, server credentials, retries and deduplication; test background and terminated app delivery. |
| Authentication | Re-test registration → Gmail OTP → profile → Home, Google sign-in, reset, expiry, logout, and cross-account access on the final signed APK. |
| Data integrity | Verify tasks, habits, goals, journal and finance CRUD on a dedicated test account, including invalid dates and ownership rejection. |
| AI | Test deployed OpenRouter success, timeout, rate-limit and provider-error handling. Keep provider secrets exclusively on the server. |
| UI | Physical-device English/Khmer, large text, dark/light themes, keyboard, offline and error-state acceptance checks. |
| Operations | Backup/restore drill, reviewed schema changes, health monitoring, rollback procedure, dependency/security review and secret exposure audit. |
| Privacy and distribution | Owner-approved privacy policy, support contact, retention/deletion rules and store disclosures if publishing to a store. |

## Signing setup

Create or select an owner-controlled keystore outside the repository. Back it up
securely; do not send passwords or keys in chat. Copy
`life_sync_app/android/key.properties.example` to `key.properties` in the same
directory and fill in values locally. The actual properties file and JKS files
are ignored by Git. Use forward slashes in the keystore path.

Release builds now fail without signing configuration; debug builds remain
available. A new signing certificate cannot update the debug-signed phone app
in place. Do not uninstall or clear user data without an agreed migration plan.
The previous APK is a test artifact, not a production-signed release.

After credentials, Firebase certificates and acceptance gates are ready:

```powershell
cd C:\Users\BultonCR7\LifeSync_Project\life_sync_app
flutter analyze
flutter test
flutter build appbundle --release --dart-define=API_BASE_URL=https://lifesync-backend-bultoncr7-dev.apps.rm3.7wse.p1.openshiftapps.com
```

Use `flutter build apk --release` with the same define for direct distribution.
Verify the certificate and retest the actual artifact, not just a debug build.
No hosting purchase, database migration, secret rotation or production deployment
is performed by this checklist.

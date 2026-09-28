# Reference-screen update

## Implemented

- Focus timer: quieter layout, circular dial and stopwatch ticks; editable
  1–180 minute duration with presets; task selection and sound controls;
  pause/resume and confirmed stop/reset. The chosen duration survives reset.
- Focus statistics: labelled, zero-filled calendar bars instead of compressing
  only the days with sessions. Quarter/year views aggregate monthly. Totals,
  history, loading, retry and empty states use the local focus repository.
- Finance analysis: month/quarter/year navigation, daily/weekly/monthly grouping,
  income/expense/net-balance series, previous-period comparisons, category donut
  and category totals. Its loading does not change the finance screen's filters.
  Net balance is explicitly labelled; it is not presented as a savings account.
- Goals: responsive overview/cards, working Define → Plan → Review → Success
  flow, editable milestone sheet, real success values and expandable milestone
  details. After a confirmed goal save and a failed milestone save, retry only
  submits the remaining milestones. Goal deadlines follow the API's future-date
  rule. Monetary fields remain because the current backend requires them.
- Goal cards now observe milestone changes directly, so returning from a
  completed milestone updates the card count without a manual refresh.
- New copy includes Khmer translations and supports light/dark surfaces.

## Backend limitations

The live goal model supports monetary goals and dated milestones. It has no
milestone-task association or persisted goal colour field. The reference's
sample task checklists, GPA targets, fake trend percentages and AI buttons are
not substituted for working backend features. No backend or database changes
are part of this update.

## Repeatable verification

`flutter test` includes interactive narrow-screen widget flows, exact-money
aggregation, leap-month and calendar-quarter tests, error/retry states and
goal partial-save recovery. The fixtures are under `test/support`, not `lib`.

Run isolated UI flows on an Android emulator:

```powershell
flutter drive --driver=test_driver/reference_driver.dart --target=integration_test/reference_flows_test.dart -d emulator-5554 --no-dds
```

This uses the actual screen widgets with in-memory repositories. It does not
authenticate to OpenShift, send OTPs or modify Neon. Screenshots are written to
`build/ui-validation`. Passing these flows does not establish live-server CRUD
success, audible sound output, or physical-device PIN authentication.

After testing, rebuild `lib/main.dart` before distributing the APK; the emulator
test build uses a separate test entry point and must not be distributed.

## Verified results — 2026-09-25

- `flutter analyze`: no issues found.
- `flutter test`: 99 tests passed.
- Pixel_8 emulator (`emulator-5554`): all four interactive scenario groups passed,
  covering focus timers/statistics, finance filters/charts, goal creation and
  milestone recovery/completion, and Khmer dark-mode empty states.
- 17 screenshots saved in `build/ui-validation` and representative screens
  visually reviewed.
- Normal `lib/main.dart` debug APK rebuilt with the deployed API URL, installed
  successfully and launched on the emulator after the fixture tests.
- Live backend authentication/CRUD and physical-phone behavior were not verified
  by these isolated tests.

# September 25 testing follow-up

## Implemented in source

- Zero habit streaks are no longer replaced by the fake value 168.
- Journal and finance entries reject future calendar dates; habit completions
  reject future/unscheduled dates. Past entries remain allowed.
- Milestone picker dates are bounded by goal creation and deadline.
- Contribution schedules have edit controls and confirmed deletion with error
  feedback. Completed contributions are not silently rewritten.
- Goal complete/archive failures are surfaced instead of ignored.
- Focus durations can be selected before starting; the choice is persisted.
- Android focus previews/completion use synthesized media audio rather than
  system clicks. Device media volume still controls playback.
- Focus chart grids remain visible with empty data; dense bars fit the chart.
- Finance shows warnings when expenses exceed income or a budget is exceeded.
- Backend OpenRouter adapter is opt-in and keeps keys out of the APK.
- Assistant requests have a longer receive timeout and no longer duplicate the
  current prompt in history.

## Not yet proven or finished

- Physical-phone sound audibility and notification delivery.
- Scheduled reminders: the existing Reminder settings route opens notification
  history; there is no local scheduling implementation in that route.
- Habit color selection is currently UI-only and needs persistent storage.
- Phone PIN/biometric app lock is implemented, but native verification still
  needs testing on the Samsung. Enable it from Settings; both enabling and
  disabling require the device credential. Restart/background locks the app.
- Finance now links to Financial Analysis with real totals, monthly bars,
  category expenses, date filtering, empty/error states and pull-to-refresh.
  Physical-phone visual and live-server validation remain pending.
- OpenRouter requires a private server key, selected model, deployment, and a
  live authenticated test; mock/configuration tests do not prove provider access.
- Backend enforcement of the new date rules, full real-device CRUD retesting,
  and visual Khmer coverage are still required.

Pomodoro is a countdown for a focused work interval; 25 minutes is a default,
not a required duration. Stopwatch counts upward for open-ended work.

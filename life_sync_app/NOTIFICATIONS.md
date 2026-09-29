# Android notifications

Enable notifications in Settings → Reminder, then approve the Android prompt.
The screen provides immediate and delayed test notifications, a due-date reminder
time, the scheduled task count, permission settings and notification history.

Incomplete tasks are scheduled locally at the chosen time on their due date.
Completed/deleted tasks are cancelled after a successful app mutation. Pending
alarms survive process termination and reboot through the plugin receivers.
Only the nearest 100 future task reminders are scheduled. Open the app to refresh
later tasks and changes made on another device. Overdue incomplete tasks use the
next occurrence of the selected daily time, not an immediate catch-up alert.
Active habits have one grouped reminder per scheduled day over a rolling seven-day
window. Completed dates are excluded. Completing, pausing, editing or deleting
habits updates these alarms. Past habit reminder times are skipped; no historical
missed-habit alert is generated. Open the app regularly to renew the window.
Data changed on another device requires a successful refresh on this phone.
Device timezone changes take effect on the next successful refresh.

Schedules are account-scoped and cancelled on logout or account changes.
Lock-screen text is generic and does not expose task names or financial amounts.
Delivery uses inexact alarms; Android battery restrictions, notification-channel
settings, force-stop, and revoked permissions can delay or prevent delivery.

The backend creates inbox alerts when an expense creation/update crosses 80% or
100% of an existing category budget. Totals use the backend's existing all-time
category budget calculation, not a monthly budget. A jump over both thresholds
creates just the limit alert. These notifications are owned by the current user.

Inbox alerts refresh every minute while the app is open and when resumed.
Network failures retain already scheduled task reminders. This is not remote
push: Firebase Messaging server configuration and device-token registration are
not implemented. Goal and focus completion reminders are not implemented
by this service.

## Physical-device acceptance checks

- Deny permission: no success indication; settings explain how to enable it.
- Allow permission and send the immediate test: verify tray entry and sound.
- Schedule the delayed test, background the app, and verify eventual delivery.
- Create a future task; update, complete and delete it; verify pending counts.
- Leave a task overdue; confirm its next daily reminder is scheduled.
- Create a habit; verify scheduled days, completion cancellation, pause/resume
  and deletion, then tap a habit reminder to open the habit list.
- Tap a task reminder: verify protected task navigation, including cold launch.
- Restart the phone before a due time and verify the reminder remains scheduled.
- Log out and switch accounts: verify no previous-account reminders remain.
- Cross a test budget threshold; verify inbox alert, ownership and read/delete.

Automated tests are not evidence of successful delivery on a physical device.

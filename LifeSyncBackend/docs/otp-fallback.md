# OTP fallback rollout

Local implementation; not deployed or applied to Neon by this change.

- Five invalid/expired codes across registration, reset, and linking block sends and verification for 15 minutes. The fifth failure invalidates the code.
- Resends never reset failed verification counters. Persistent user fields and pessimistic row locks protect concurrent requests and server restarts.
- One send per minute; five resend/recovery/link sends per 15-minute window. A sixth request blocks OTP operations for 15 minutes.
- Three Gmail resend attempts unlock Telegram requests. Provider failures count as attempts, not confirmed delivery.
- HTTP 429 contains Retry-After and retryAfterSeconds. Remaining seconds are server-authoritative.
- Registration and password-reset codes cannot be used interchangeably. Existing codes issued before rollout must be resent.

## Deployment

Configure LIFESYNC_TELEGRAM_BOT_TOKEN privately as an OpenShift Secret environment variable. Do not commit it or paste it into chat. Start a private conversation with the bot before linking.

Review and apply otp-policy.sql before deploying if automatic schema updates are disabled. Current local configuration uses Hibernate update and disables Flyway; do not enable a new Flyway baseline against an existing database casually. Deploy backend before the Flutter client. No database reset is needed.

## Linking

Telegram cannot prove ownership of an email address. New accounts still need Gmail verification first; this fallback cannot safely replace initial email ownership verification. A missing link produces a clear error and never accepts a caller-supplied recipient on a public recovery endpoint.

Authenticated, email-verified users can link from the Profile toolbar using the Link Telegram button. The flow uses POST /api/auth/telegram/link with JSON chatId (positive private chat ID), then POST /api/auth/telegram/confirm with JSON otpCode received in Telegram. Both require the existing bearer session. The link is committed only after the Telegram code is verified.

After three Gmail requests, POST /api/auth/resend-otp?email=...&channel=telegram sends only to that stored link. Omit channel or use email for Gmail. For verified accounts, start forgot-password before recovery resends.

Live Gmail/Telegram delivery, migration, deployment, and physical-phone lockout verification remain rollout checks. Never inspect codes in backend logs or the database.

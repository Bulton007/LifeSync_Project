# OpenShift deployment

Build the backend JAR and stage only that JAR as `app.jar` together with
`Dockerfile.openshift` renamed to `Dockerfile` for the binary build. Never upload
the repository root, local environment files, or application logs.

The image starts with the `openshift` profile and explicit schema validation.
Flyway, Liquibase, and SQL initialization are disabled. A schema mismatch must
block startup; do not enable automatic schema updates to bypass it.

Required writable-path overrides for the deployment:

```text
LOGGING_FILE_NAME=/tmp/lifesync/app.log
LOGGING_LOGBACK_ROLLINGPOLICY_TOTAL_SIZE_CAP=100MB
LOGGING_LOGBACK_ROLLINGPOLICY_MAX_HISTORY=7
SERVER_TOMCAT_BASEDIR=/tmp/lifesync-tomcat
```

Map application environment variables to the existing `lifesync-secrets` keys
using `secretKeyRef`, never literal credentials:

| Application variable | Existing Secret key |
| --- | --- |
| `DB_URL` | `DATABASE_URL` |
| `DB_USERNAME` | `DATABASE_USERNAME` |
| `DB_PASSWORD` | `DATABASE_PASSWORD` |
| `LIFESYNC_TELEGRAM_BOT_TOKEN` | `TELEGRAM_BOT_TOKEN` |

The Gmail and JWT variable names already match the existing Secret keys.

Use `/actuator/health/liveness` for startup/liveness and
`/actuator/health/readiness` for readiness. Readiness includes the database;
health details are not publicly exposed. Keep rolling updates at `maxSurge: 1`
and `maxUnavailable: 0` when quota permits so a failed new image does not remove
the existing healthy pod. Record the previous image digest for rollback.

Verify the deployed image digest, ready replica count, both probe endpoints,
and `/api/health` after rollout. A successful image build alone does not prove
that the application or Gmail delivery works.

## September 20, 2026 rollout blocker

Build `lifesync-backend-4` completed, but startup validation rejected the new
image because `users.otp_blocked_until` is missing. This is the first reported
mismatch, not proof that all other required columns exist. No migration was
applied. The previous image was selected again. The OTP policy changes cannot
be deployed safely without an explicitly approved, reviewed schema update or
a separately designed schema-compatible implementation.

## September 24, 2026 schema verification

The application role could inspect schema metadata but could not alter `users`
(`must be owner of table users`). Its attempted migration rolled back. The user
then executed the reviewed additive migration through Neon's SQL Editor with
an owner role. A subsequent metadata-only inspection through the deployment's
database connection confirmed all nine nullable OTP/Telegram columns and their
expected types. Existing record contents were not read or changed by the
migration. Keep the runtime role restricted and schema auto-update disabled.

Build 5 failed while receiving binary input, before image compilation. It was
not deployed. A retry uses a longer upload timeout.

Build 6 completed and was successfully deployed after schema verification.
The deployment now mounts a single-attach persistent volume. The attempted
surge rollout hit `FailedAttachVolume` on a different node, so its strategy was
changed to `maxSurge: 0`, `maxUnavailable: 1`. This releases the old pod's volume
before replacement and involves brief downtime; do not restore surge updates
without reviewing the storage access mode and scheduling constraints.

Post-rollout checks: `/api/health` and `/actuator/health/readiness` returned 200;
unauthenticated `/api/auth/check-email` returned 200 with `exists: false` for a
synthetic `.invalid` email; `/api/users/1` returned 401 without credentials.
These checks do not establish Gmail delivery or a complete registration flow.

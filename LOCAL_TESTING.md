# Local LifeSync testing (without OpenShift)

API origin: **http://localhost:8085**. Health: **http://localhost:8085/api/health**.
Flutter already accepts `API_BASE_URL`; the checked-in local configs make switching
explicit. There is no automatic fallback: local and hosted accounts/data differ.
The existing OpenShift default and deployment are unchanged.

## Docker Compose

Install/start Docker Desktop with Linux containers. From the repository root:

```powershell
cd LifeSyncBackend
docker compose --env-file local-services.example -f docker-compose.local.yml up --build -d
docker compose --env-file local-services.example -f docker-compose.local.yml ps
curl.exe http://localhost:8085/api/health
```

Use **docker-compose.local.yml**, not the older OpenShift-oriented compose file.
The multi-stage build requires no local Java installation and downloads Maven
dependencies. It skips build-time tests so real-database tests cannot run during
image construction. Run the safe automated test suite separately.

This stack has its own PostgreSQL, Redis and persistent upload volume. Only the
backend port is published, on the host's loopback interface. It does not connect
to Neon. The `local-docker` profile initializes this local database schema;
never use it with a production database. Credentials and JWT key in these local
files are public test values, not production secrets.

Stop without deleting data:

```powershell
docker compose --env-file local-services.example -f docker-compose.local.yml down
```

Do not add `-v` unless you intend to erase local database and photo volumes.

## Flutter on a USB-connected Android phone

From `life_sync_app` (select a device with `-d DEVICE_ID` if needed):

```powershell
adb reverse tcp:8085 tcp:8085
flutter run --debug --dart-define-from-file=config/local.json
```

USB reverse makes the phone's localhost reach your computer. Repeat it after
reconnecting/rebooting. Without it, localhost means the phone, not the computer.

For an Android emulator:

```powershell
flutter run --debug --dart-define-from-file=config/emulator.json
```

The emulator config maps localhost to `10.0.2.2`. Local HTTP is enabled only for
Android debug builds. Release builds still require HTTPS; do not weaken that
protection for a local demo. The `.env` file is not automatically read by Flutter.

## Local Kubernetes alternative

Use a local cluster such as Docker Desktop Kubernetes. Check contexts first:

```powershell
kubectl config get-contexts
docker build -f LifeSyncBackend/Dockerfile.local -t lifesync-backend:local LifeSyncBackend
kubectl --context docker-desktop apply -f LifeSyncBackend/kubernetes/local.yaml
kubectl --context docker-desktop -n lifesync-local rollout status deployment/backend --timeout=300s
kubectl --context docker-desktop -n lifesync-local port-forward service/backend 8085:8085
```

Keep port-forward running. Use the same Flutter commands above; stop Compose
first to free port 8085. If your local context has another name, substitute it
explicitly. **Never apply these test manifests to your OpenShift context.**
The cluster needs a default dynamic StorageClass for the PostgreSQL and upload
PVCs. Backend uses `imagePullPolicy: Never`: import the built image into the
cluster if it does not share Docker's image store (for example with kind's
`kind load docker-image lifesync-backend:local`). Wait for PostgreSQL readiness
if the backend restarts during first initialization.

## External services and accounts

Local accounts are separate; hosted passwords/accounts are not copied. Gmail
OTP, Telegram and AI need your own service credentials and network access.
No authentication bypass or OTP logging is provided. For Compose, copy
`local-services.example` to `.env.local`, fill it privately, and replace the
`--env-file` argument with `.env.local`. Never commit that file.
For Kubernetes, configure credentials through a namespace-scoped Secret and
environment references; none are supplied in the manifests. Google sign-in
also requires the matching local Firebase Android file and server verification
configuration. Merely starting the stack does not prove these services work.

## Validation status

Compose configuration validated. Runtime startup could not be tested because
Docker Desktop's Linux engine was not running. No Kubernetes deployment was
attempted: the current context was the live OpenShift cluster.

param([ValidateSet('Inspect', 'Apply')][string]$Action = 'Inspect')
$ErrorActionPreference = 'Stop'
$secretJson = oc get secret lifesync-secrets -n bultoncr7-dev --request-timeout=20s -o json
if ($LASTEXITCODE -ne 0) { throw 'Unable to read deployment database configuration.' }
$secret = $secretJson | ConvertFrom-Json
function Decode-Value([string]$value) {
    [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($value))
}
$databaseUrl = Decode-Value $secret.data.DATABASE_URL
$databaseUri = [Uri]($databaseUrl -replace '^jdbc:', '')
$names = @('PGHOST','PGPORT','PGDATABASE','PGUSER','PGPASSWORD','PGSSLMODE','PGCONNECT_TIMEOUT')
$previous = @{}
foreach ($name in $names) { $previous[$name] = [Environment]::GetEnvironmentVariable($name, 'Process') }
try {
    $env:PGHOST = $databaseUri.Host
    $env:PGPORT = if ($databaseUri.Port -gt 0) { "$($databaseUri.Port)" } else { '5432' }
    $env:PGDATABASE = [Uri]::UnescapeDataString($databaseUri.AbsolutePath.TrimStart('/'))
    $env:PGUSER = Decode-Value $secret.data.DATABASE_USERNAME
    $env:PGPASSWORD = Decode-Value $secret.data.DATABASE_PASSWORD
    $env:PGSSLMODE = 'require'
    $env:PGCONNECT_TIMEOUT = '15'
    $psql = 'C:\Program Files\PostgreSQL\18\bin\psql.exe'
    if ($Action -eq 'Apply') {
        & $psql -X -v ON_ERROR_STOP=1 -f (Join-Path $PSScriptRoot 'otp-policy.sql')
        if ($LASTEXITCODE -ne 0) { throw 'OTP migration failed; inspect the transaction result before retrying.' }
    }
    & $psql -X -v ON_ERROR_STOP=1 -c "SELECT column_name, data_type, character_maximum_length, is_nullable FROM information_schema.columns WHERE table_schema='public' AND table_name='users' ORDER BY ordinal_position;"
    if ($LASTEXITCODE -ne 0) { throw 'Schema inspection failed.' }
} finally {
    foreach ($name in $names) { [Environment]::SetEnvironmentVariable($name, $previous[$name], 'Process') }
    $secret = $null
    $secretJson = $null
    $databaseUrl = $null
}

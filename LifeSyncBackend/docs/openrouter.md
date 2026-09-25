# OpenRouter setup

Set `AI_PROVIDER=openrouter` and a supported `OPENROUTER_MODEL` in the backend
environment. Store `OPENROUTER_API_KEY` privately in the OpenShift Secret.
Never put the provider key in Flutter Dart defines, source, or the APK.

The authenticated `/api/assistant/chat` contract is unchanged. Existing Gemini
behavior is available with `AI_PROVIDER=gemini`; OpenRouter is now the default
when `AI_PROVIDER` is not set. An existing deployment override must be changed
explicitly to `openrouter`. Redeploy the backend after updating the configuration.
Only the submitted prompt and recent chat history are sent to OpenRouter;
this adapter does not read journals, financial transactions, or other app data.
Requests can incur provider charges. Live testing requires a configured key,
an accessible model, and account credit. No live provider call is made by unit tests.

Reference: https://openrouter.ai/docs/api_reference/overview

## Activate in OpenShift

1. Store `OPENROUTER_API_KEY` in a Secret through the OpenShift console.
2. In the LifeSync backend Deployment's Environment tab, reference that Secret
   for `OPENROUTER_API_KEY`. Set `AI_PROVIDER=openrouter` and
   `OPENROUTER_MODEL` to the exact model ID available to your OpenRouter account.
3. Build/deploy the updated backend and wait for readiness. Do not change Neon.
4. Sign in to LifeSync and open LifeSync AI. Submit a non-sensitive prompt and
   verify a reply. A successful build alone does not verify live AI access.

Flutter uses the authenticated backend endpoint, not a direct OpenRouter key.
Chat supports planning tasks, breaking goals into milestones, habits, journaling
and budgeting suggestions. It does not automatically read or modify user records.
History sent by Flutter is limited to eight non-error messages. No automatic
provider fallback is used for an unrecognized `AI_PROVIDER` value.

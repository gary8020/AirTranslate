# AirTranslate 1.6.0

AirTranslate 1.6.0 adds an optional Gemini source-transcription workflow and makes long-running Gemini sessions and compact macOS layouts more resilient without changing Apple Mode as the local-first default.

AirTranslate is an independent open-source project and is not affiliated with Apple, OpenAI, or Google.

## Added

- Added **Gemini 3.5 Transcribe Live**, an opt-in source-only caption mode that automatically detects the spoken language during capture when the user provides a Gemini API key.

## Changed

- Gemini Live now recognizes finished session state, reuses the latest session-resumption handle during refreshes, follows GoAway reconnect recommendations, bounds retained context through compression, and sends audio in 40 ms chunks for more reliable long-running capture.
- The minimum-size workspace and Settings layouts reflow instead of hiding controls.
- Apple, GPT, and Gemini transcription modes now use one original-only output contract: no translated-text route, target-language picker, or translated-voice controls are shown where translation is not part of the active mode.

## Fixed

- Compact windows no longer clip the transcription-mode controls that remain available at the minimum supported size.
- Original-only transcription no longer exposes translation-only controls that cannot affect the current session.

## Scope

- Apple Mode remains the default local-first transcription and translation path.
- Gemini 3.5 Transcribe Live is optional, sends audio to Gemini only after the user enables it and provides a Gemini API key, and produces source captions rather than translations.
- This release does not add an account system or a developer-operated relay/backend server. Optional OpenAI and Gemini modes still send the audio or text needed for the selected feature directly to their external APIs using user-provided keys stored in macOS Keychain.
- Gemini Live Translate and Gemini 3.5 Transcribe Live send required audio directly to the Google Gemini API only after the user enables the mode and provides a Gemini API key; keys are never included in release packages.
- This release does not change the existing ad-hoc signing and non-notarized distribution status.

## Verification

- The source change set has focused Gemini-session regression coverage for finished state, resumption, GoAway handling, context compression, and 40 ms audio transmission.
- Release candidates are built from the repository source and checked for expected app, license, notice, checksum, code-signature, and sensitive-file boundaries before any upload.
- Actual Gemini API connectivity, live audio transcription, and long-duration provider-session continuity require a separately configured user API key and are not implied by local build or test results.
- macOS Gatekeeper may still show an unidentified-developer warning because these open-source artifacts are ad-hoc signed and not Apple-notarized.

## Download

- [Repository](https://github.com/himomohi/AirTranslate)
- [AirTranslate 1.6.0 release](https://github.com/himomohi/AirTranslate/releases/tag/v1.6.0)
- [Latest stable DMG download](https://github.com/himomohi/AirTranslate/releases/latest/download/AirTranslate.dmg)

## Distribution Notes

AirTranslate remains fully open-source under the Apache-2.0 License. Release DMG and ZIP artifacts are ad-hoc signed and are not Apple-notarized; macOS may show an unidentified-developer warning on first launch.

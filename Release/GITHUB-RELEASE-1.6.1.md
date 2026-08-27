# AirTranslate 1.6.1

AirTranslate 1.6.1 is a focused macOS hotfix for Gemini Live start behavior, capture-start recovery, and current-build permission guidance.

AirTranslate is an independent open-source project and is not affiliated with Apple, OpenAI, or Google.

## Fixed

- The top Start control now begins capture in the selected Gemini Live mode.
- During capture startup, locked segmented controls no longer use AppKit's dynamic disabled state. They remain visibly locked while avoiding the `NSSegmentedCell` focus-navigation/AttributeGraph CPU loop that could hold CPU use near 100%.
- A capture-start failure now stays in the main window and offers the appropriate recovery action: open API Key Settings, open the relevant macOS Privacy Settings pane, or retry.
- Local launch verification now checks that the running process is the executable inside the current `dist/AirTranslate.app`, preventing a stale 1.5.1 copy with the same bundle identifier from being mistaken for the current build.
- Permission guidance identifies the current signed AirTranslate build. When macOS does not recognize it, retain the active copy, refresh only the affected permission once, then quit and relaunch; routine TCC resets are not needed.

## Scope

- Apple Mode remains the default local-first transcription and translation path.
- Gemini Live is optional and uses the user-provided Gemini API key stored in macOS Keychain. AirTranslate has no developer-operated relay or backend server.
- This hotfix does not alter the 1.6.0 Gemini source-transcription feature set or the existing Apple, GPT, and Gemini provider data boundaries.

## Verification

- The change set includes focused regression coverage for actionable capture-start recovery and the segmented-control native-disabled-state guard.
- Release candidates are built from repository source and checked for the app bundle, version/build metadata, LICENSE, NOTICE, code-signature integrity, ZIP/DMG contents, checksums, and sensitive-file boundaries before upload.
- Local executable verification proves the exact launched bundle path; it does not prove real Gemini API connectivity, live audio transcription, or long-duration provider-session continuity, which require a separately configured user API key.
- macOS Gatekeeper may still show an unidentified-developer warning because these open-source artifacts are ad-hoc signed and are not Apple-notarized.

## Download

- [Repository](https://github.com/himomohi/AirTranslate)
- [AirTranslate 1.6.1 release](https://github.com/himomohi/AirTranslate/releases/tag/v1.6.1)
- [Latest stable DMG download](https://github.com/himomohi/AirTranslate/releases/latest/download/AirTranslate.dmg)

## Distribution Notes

AirTranslate remains fully open-source under the Apache-2.0 License. Release DMG and ZIP artifacts are ad-hoc signed and are not Apple-notarized; macOS may show an unidentified-developer warning on first launch.

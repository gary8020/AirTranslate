# AirTranslate 1.7.0

AirTranslate 1.7.0 adds optional Meta Scribe transcription, replaces the settings sidebar with a Stage & Console workspace, and keeps Apple Mode responsive during long sessions.

AirTranslate is an independent open-source project and is not affiliated with Apple, OpenAI, Google, or Meta.

## Added

- **Meta Scribe** uses Muse Voice Transcribe for realtime transcription, speaker labels, and 25-language code-switching before AirTranslate's existing translation layer. This mode is optional and requires a user-provided Meta API key from Settings.

## Changed

- The main window is now a **Stage & Console** layout. Live captions fill the window as turn-based blocks (source line above a larger translated line, speaker chip when available, newest turn just above the console). A floating console bar holds Start/Stop with a live audio meter, Pause, audio source, language route, output mode, voice output and volume, and the active engine badge. On narrow windows the secondary controls collapse into a More menu. The settings sidebar is gone; detailed setup remains in the gear-shaped Settings window.
- A shared **Air teal** design system applies listening, paused, and stopped colors, layered surfaces, and a caption typography scale across the main window, Settings, transcript library, floating captions, and menu bar in light and dark appearance.
- Keyboard navigation uses an accent-colored **focus ring**. Start receives initial focus, and session-locked controls stay dimmed with a single lock indicator while remaining fully described to assistive technologies.

## Fixed

- Apple Mode no longer slows down over long sessions. It now **rolls the live line** into a new turn block after roughly 600 committed characters or a long silence, with a replay guard so late final results that revise an already-rolled sentence merge instead of duplicating. Saved transcripts and the library still contain the full session text across all blocks.
- The Stage could go blank after a long session or a stop/start cycle. The transcript feed now renders the **12 most recent** turn blocks with a plain stack, which fixes disappearing captions and keeps rendering cost constant.

## Scope

- Apple Mode remains the default local-first transcription and translation path.
- Meta Scribe, GPT, and Gemini modes remain optional. Each sends the audio or text needed for the selected feature directly to the corresponding external API using a user-provided key stored in macOS Keychain.
- Meta Scribe sends required audio to Meta's Muse Voice Transcribe API only after the user enables the mode and provides a Meta API key; keys are never included in release packages. Actual Meta API connectivity is not implied by local tests.
- This release does not add an account system or a developer-operated relay/backend server.
- This release does not change the existing ad-hoc signing and non-notarized distribution status.

## Verification

- Focused `AppleCaptionRolloverTests` coverage verifies rollover after committed growth, replay-guard merge of late finals, silence-triggered shorter blocks, saved multi-line transcripts, and bounded per-update work.
- Local tests and a 40-minute Apple Mode session with YouTube system audio confirmed that store-side work no longer grows with total transcript length, and the Stage stayed visible.
- Release candidates are built from repository source and checked for version/build metadata, the app bundle, LICENSE, NOTICE, code-signature integrity, ZIP/DMG contents, and checksums.
- Local tests and packaged artifacts do not prove Meta, OpenAI, or Gemini live connectivity; those paths require separately configured user API keys.
- macOS Gatekeeper may still show an unidentified-developer warning because these open-source artifacts are ad-hoc signed and not Apple-notarized.

## Download

- [Repository](https://github.com/himomohi/AirTranslate)
- [AirTranslate 1.7.0 release](https://github.com/himomohi/AirTranslate/releases/tag/v1.7.0)
- [Latest stable DMG download](https://github.com/himomohi/AirTranslate/releases/latest/download/AirTranslate.dmg)

## Distribution Notes

AirTranslate remains fully open-source under the Apache-2.0 License. Release DMG and ZIP artifacts are ad-hoc signed and are not Apple-notarized; macOS may show an unidentified-developer warning on first launch, and TCC permission inheritance across updates is not guaranteed.

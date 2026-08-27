# AirTranslate Privacy Notice Draft

AirTranslate transcribes and translates audio playing on the user's Mac.

AirTranslate is an independent open-source project and is not affiliated with Apple, OpenAI, or Google.

## Data Handling

- AirTranslate does not require an account.
- AirTranslate has no developer-operated relay or backend server. This does not mean optional provider modes are offline: when enabled, they send the audio or text needed for the selected feature directly to the corresponding external API.
- AirTranslate does not include analytics, ads, tracking SDKs, or telemetry SDKs.
- Captured audio is used for live transcription and translation while the user has capture running.
- Saved transcripts are stored locally as plain-text files under the user's `~/Library/Application Support/AirTranslate/Transcripts` directory.
- Settings are stored locally with macOS app preferences.

## Apple System Services

AirTranslate uses Apple system frameworks, including ScreenCaptureKit, Speech, and Translation.

Speech recognition and language assets may be processed or downloaded through Apple-managed system services. AirTranslate does not send audio, transcripts, or translations to a server operated by this app's developer.

## Optional OpenAI GPT Mode

GPT mode is optional and works only after the user provides an OpenAI API key.

When GPT mode or an OpenAI translation model is enabled, AirTranslate sends the necessary audio or text to OpenAI's API to produce realtime transcription, translation, or translated audio output.

OpenAI API keys are user-provided runtime data. AirTranslate stores them in macOS Keychain and does not include API keys in the source tree, release scripts, or generated release bundles.

## Optional Gemini Live and Transcription Modes

Gemini Live Translate and Gemini 3.5 Transcribe Live are optional and work only after the user provides a Gemini API key.

When either Gemini mode is enabled, AirTranslate sends the audio needed for the selected live translation or source-only transcription feature directly to the Google Gemini API. Gemini 3.5 Transcribe Live automatically detects the spoken language and returns source captions rather than translations.

Gemini API keys are user-provided runtime data. AirTranslate stores them in macOS Keychain and does not include API keys in the source tree, release scripts, or generated release bundles.

## Permissions

AirTranslate requests only permissions tied to its core function:

- Screen Recording, because ScreenCaptureKit requires it for system audio capture.
- System Audio Recording, because the app captures audio playing on the Mac.
- Microphone, because the app captures microphone audio only after the user selects Microphone input and starts capture.
- Speech Recognition, because the app converts captured audio into text.

AirTranslate does not request Contacts, Calendar, Photos, Location, browser data, or Full Disk Access.

# AirTranslate 1.6.2

AirTranslate 1.6.2 is a focused macOS patch for repeated Screen Recording permission requests, clearer TCC identity recovery, and a hidden Settings control loop that could block Gemini Live startup.

AirTranslate is an independent open-source project and is not affiliated with Apple, OpenAI, or Google.

## Fixed

- AirTranslate requests Screen Recording access only on the first attempt that actually needs it. If access remains unavailable later, the app shows the macOS Privacy & Security recovery path instead of reopening the system request on every capture start.
- A preflight approval still takes priority, so permission granted in System Settings is used without another in-app request.
- Permission guidance now calls out TCC identity conflicts. Older AirTranslate copies or differently signed builds can share the same `dev.appcaster.AirTranslate` bundle identifier while macOS treats them as different permission identities. Remove or archive the other copies, keep only the installation you intend to run, and confirm that exact app in System Settings.
- The hidden Settings Scene no longer changes a segmented `Picker` to disabled while capture starts. That invisible transition could trigger an AppKit focus-navigation/AttributeGraph CPU loop and make the top Gemini Live Start control appear frozen; startup now proceeds without the hidden settings control participating.

## Installation And Permission Guidance

1. Remove or archive older AirTranslate copies from Applications, Downloads, development `dist` folders, and other launch locations. Keep one intended installation.
2. Install the current `AirTranslate.app`, launch that copy, and verify its version in **Settings > About**.
3. On the first capture that needs Screen Recording, respond to the macOS request and quit/relaunch if macOS asks you to do so.
4. If a later capture still reports unavailable access, open **System Settings > Privacy & Security > Screen & System Audio Recording**, confirm the current app there, then quit and relaunch. AirTranslate will not repeatedly reopen the system permission request.
5. If Gemini Live Start previously appeared stuck even after permissions were correct, install and launch 1.6.2. This release removes the hidden Settings segmented-control transition that could consume CPU and prevent startup progress.

The public DMG and ZIP are ad-hoc signed. Because ad-hoc signing does not give every update a stable designated identity for TCC, Screen Recording permission is not guaranteed to carry over from one public build to the next. A newly installed update may need to be confirmed again in System Settings. This is a distribution limitation, not evidence that AirTranslate records screen video; ScreenCaptureKit is used for system-audio capture and AirTranslate does not save screen frames as recordings.

## Scope

- Apple Mode remains the default local-first transcription and translation path.
- GPT and Gemini modes remain optional and use the API keys provided by the user and stored in macOS Keychain.
- This patch changes the Screen Recording request policy and removes the hidden Settings segmented-control participation in capture startup. It does not change provider data boundaries.

## Verification

- Focused regression coverage verifies that multiple capture objects and a recreated policy share the persisted request-attempt state, so the system request runs once.
- Separate coverage verifies that a current TCC preflight approval succeeds without calling the system request.
- Settings presentation coverage keeps the hidden scene out of active capture-start control transitions, preventing the AppKit focus-navigation/AttributeGraph loop from blocking Gemini Live Start.
- Release candidates are built from repository source and checked for version/build metadata, the app bundle, LICENSE, NOTICE, code-signature integrity, ZIP/DMG contents, and checksums.
- Local tests and packaged artifacts do not prove TCC inheritance across separately downloaded ad-hoc builds; that inheritance is explicitly not guaranteed.

## Download

- [Repository](https://github.com/himomohi/AirTranslate)
- [AirTranslate 1.6.2 release](https://github.com/himomohi/AirTranslate/releases/tag/v1.6.2)
- [Latest stable DMG download](https://github.com/himomohi/AirTranslate/releases/latest/download/AirTranslate.dmg)

## Distribution Notes

AirTranslate remains fully open-source under the Apache-2.0 License. Release DMG and ZIP artifacts are ad-hoc signed and are not Apple-notarized; macOS may show an unidentified-developer warning on first launch, and TCC permission inheritance across updates is not guaranteed.

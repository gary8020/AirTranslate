import Foundation
import Testing
@testable import AirTranslate

@Suite(.serialized)
struct MetaTranslationSessionStoreTests {
    @Test
    @MainActor
    func selectingMetaIsMutuallyExclusiveWithOtherProviders() {
        let suiteName = "MetaTranslationSessionStoreTests.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defer { defaults.removePersistentDomain(forName: suiteName) }
        let session = TranslationSessionStore(
            modelAvailabilityProvider: { _, _ in [:] },
            settingsDefaults: defaults
        )
        session.useGeminiMode(.gemini35LiveTranslate)
        session.useMetaScribeMode()

        #expect(session.isUsingMetaScribe)
        #expect(session.metaTranscriptionModel == .museVoiceTranscribe)
        #expect(session.openAITranscriptionModel == .off)
        #expect(session.openAITranslationModel == .off)
        #expect(session.geminiTranslationModel == .off)
        #expect(session.selectedModel == .appleSystem)
        #expect(!session.isTranscribeOnlyMode)

        session.useGPTRealtimeMode()
        #expect(session.metaTranscriptionModel == .off)

        session.useMetaScribeMode()
        session.useGeminiMode(.gemini35TranscribeLive)
        #expect(session.metaTranscriptionModel == .off)
    }

    @Test
    @MainActor
    func metaModelAndSpeakerLabelsPersistAndRestore() {
        let suiteName = "MetaTranslationSessionStoreTests.\(UUID().uuidString)"
        let defaults = try! #require(UserDefaults(suiteName: suiteName))
        defer { defaults.removePersistentDomain(forName: suiteName) }

        let first = TranslationSessionStore(
            modelAvailabilityProvider: { _, _ in [:] },
            settingsDefaults: defaults
        )
        first.useMetaScribeMode()
        first.isMetaSpeakerLabelsEnabled = false

        let restored = TranslationSessionStore(
            modelAvailabilityProvider: { _, _ in [:] },
            settingsDefaults: defaults
        )
        #expect(restored.metaTranscriptionModel == .museVoiceTranscribe)
        #expect(!restored.isMetaSpeakerLabelsEnabled)
        #expect(restored.geminiTranslationModel == .off)
        #expect(restored.openAITranslationModel == .off)
        #expect(restored.selectedModel == .appleSystem)
    }

    @Test
    func metaConfigurationUsesTwentyFourKilohertzAndStillTranslates() {
        let configuration = StartConfiguration(
            audioInputSource: .systemAudio,
            microphoneDeviceUniqueID: nil,
            sourceLanguage: .english,
            targetLanguage: .korean,
            selectedModel: .appleSystem,
            openAITranscriptionModel: .off,
            openAITranslationModel: .off,
            geminiTranslationModel: .off,
            metaTranscriptionModel: .museVoiceTranscribe,
            usesMetaSpeakerLabels: true,
            usesAppleSourceAutoDetection: false
        )

        #expect(configuration.sampleRate == 24_000)
        #expect(!configuration.isTranscribeOnlyMode)
    }

    @Test
    func readinessRequiresMetaKeyBeforeLocalTranslationAssets() {
        let assessment = StartReadinessPolicy.assess(
            requiresOpenAIAPIKey: false,
            hasOpenAIAPIKey: false,
            requiresGeminiAPIKey: false,
            hasGeminiAPIKey: false,
            requiresMetaAPIKey: true,
            hasMetaAPIKey: false,
            requiredLocalModelAvailability: nil
        )

        #expect(assessment.issue == .metaAPIKeyMissing)
        #expect(!assessment.canStart)
    }

    @Test
    @MainActor
    func twoMetaTurnsRemainInTranslationFIFO() {
        let suiteName = "MetaTranslationSessionStoreTests.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defer { defaults.removePersistentDomain(forName: suiteName) }
        let session = TranslationSessionStore(
            modelAvailabilityProvider: { _, _ in [:] },
            settingsDefaults: defaults
        )
        let lineIDs = [UUID(), UUID()]

        #expect(session.verifyOrderedMetaTranslationLineIDsForTesting(lineIDs) == lineIDs)
    }
}

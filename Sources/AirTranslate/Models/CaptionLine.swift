import Foundation
import AirTranslateCore

struct CaptionLine: Identifiable, Equatable {
    private static let maxDisplayCharacters = 4_000

    let id: UUID
    let sourceText: String
    let sourceDisplayText: String
    let translatedText: String
    let translatedDisplayText: String
    let translatedSourceText: String
    let createdAt: Date
    let isFinal: Bool
    let revision: Int
    let speakerLabel: String?

    init(
        id: UUID = UUID(),
        sourceText: String,
        translatedText: String,
        translatedSourceText: String = "",
        createdAt: Date,
        isFinal: Bool,
        revision: Int = 0,
        speakerLabel: String? = nil,
        usesLongSessionDisplay: Bool = false
    ) {
        self.id = id
        self.sourceText = sourceText
        self.sourceDisplayText = Self.displayText(for: sourceText, usesLongSessionDisplay: usesLongSessionDisplay)
        self.translatedText = translatedText
        self.translatedDisplayText = Self.displayText(for: translatedText, usesLongSessionDisplay: usesLongSessionDisplay)
        self.translatedSourceText = translatedSourceText
        self.createdAt = createdAt
        self.isFinal = isFinal
        self.revision = revision
        self.speakerLabel = speakerLabel
    }

    private static func displayText(for text: String, usesLongSessionDisplay: Bool) -> String {
        guard usesLongSessionDisplay
            || text.utf8.count > Self.maxDisplayCharacters && text.count > Self.maxDisplayCharacters
        else {
            return text
        }

        return TranscriptTextProcessor.displayTail(
            from: text,
            maxCharacters: Self.maxDisplayCharacters
        )
    }
}

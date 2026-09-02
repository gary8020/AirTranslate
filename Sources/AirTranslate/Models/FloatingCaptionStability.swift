import Foundation

/// Controls how aggressively the floating caption window holds already-shown
/// text before letting a rewrite replace it.
enum FloatingCaptionStability: String, CaseIterable, Identifiable {
    case responsive
    case balanced
    case steady

    var id: String { rawValue }

    var title: String {
        switch self {
        case .responsive:
            AppText.captionStabilityResponsive
        case .balanced:
            AppText.captionStabilityBalanced
        case .steady:
            AppText.captionStabilitySteady
        }
    }

    var systemImage: String {
        switch self {
        case .responsive:
            "hare"
        case .balanced:
            "scale.3d"
        case .steady:
            "tortoise"
        }
    }

    var profile: FloatingCaptionStabilityProfile {
        switch self {
        case .responsive:
            FloatingCaptionStabilityProfile(
                earlyRevisionWindow: 0.45,
                minimumDwell: 0.8,
                maximumDwell: 1.4,
                translationHoldTimeout: 4.0
            )
        case .balanced:
            FloatingCaptionStabilityProfile(
                earlyRevisionWindow: 0.45,
                minimumDwell: 1.2,
                maximumDwell: 2.2,
                translationHoldTimeout: 6.0
            )
        case .steady:
            FloatingCaptionStabilityProfile(
                earlyRevisionWindow: 0.2,
                minimumDwell: 1.8,
                maximumDwell: 3.2,
                translationHoldTimeout: 8.0
            )
        }
    }
}

/// Timing values shared by the floating source and translation presenters.
///
/// The dwell grows with how much unread text the last replacement introduced so
/// long rewrites stay on screen long enough to be read, then is clamped to the
/// profile bounds.
struct FloatingCaptionStabilityProfile: Equatable, Sendable {
    /// Rewrites arriving this soon after a replacement may still swap in place;
    /// the recognizer is usually correcting the words it just emitted.
    let earlyRevisionWindow: TimeInterval
    let minimumDwell: TimeInterval
    let maximumDwell: TimeInterval
    /// How long a translation for an already-replaced source stays visible while
    /// the translation for the new source is still pending.
    let translationHoldTimeout: TimeInterval

    static let charactersPerDwellSecond = 28.0
    static let baseDwell = 0.9

    func dwell(forUnreadLength unreadLength: Int) -> TimeInterval {
        let dwell = Self.baseDwell + Double(max(0, unreadLength)) / Self.charactersPerDwellSecond
        return min(max(minimumDwell, dwell), maximumDwell)
    }
}

import SwiftUI

enum FloatingCaptionTextSize: String, CaseIterable, Identifiable {
    case small
    case medium
    case large
    case extraLarge

    var id: String { rawValue }

    var title: String {
        switch self {
        case .small:
            AppText.textSizeSmall
        case .medium:
            AppText.textSizeMedium
        case .large:
            AppText.textSizeLarge
        case .extraLarge:
            AppText.textSizeExtraLarge
        }
    }

    var primaryFont: Font {
        .system(size: primaryPointSize, weight: .semibold)
    }

    var secondaryFont: Font {
        .system(size: secondaryPointSize, weight: .medium)
    }

    var primaryLineHeight: CGFloat {
        primaryPointSize * 1.24
    }

    var secondaryLineHeight: CGFloat {
        secondaryPointSize * 1.28
    }

    /// Fallback wrap budget used until the floating window reports its real width.
    var floatingLineWidthUnits: Double {
        switch self {
        case .small:
            39
        case .medium:
            32
        case .large:
            25
        case .extraLarge:
            20
        }
    }

    /// Converts the measured text width of the floating window into formatter
    /// width units. One unit is one em of the given font, which matches the
    /// formatter's CJK width and slightly overestimates Latin glyphs so wrapped
    /// lines never exceed the real width and SwiftUI does not re-wrap them.
    static func lineWidthUnits(forAvailableWidth width: CGFloat, pointSize: CGFloat) -> Double {
        guard width > 0, pointSize > 0 else { return 0 }
        return Double(width / pointSize)
    }

    var primaryPointSize: CGFloat {
        switch self {
        case .small:
            24
        case .medium:
            30
        case .large:
            38
        case .extraLarge:
            48
        }
    }

    var secondaryPointSize: CGFloat {
        switch self {
        case .small:
            16
        case .medium:
            20
        case .large:
            24
        case .extraLarge:
            30
        }
    }
}

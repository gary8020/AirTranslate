import SwiftUI

enum FloatingCaptionTextAlignment: String, CaseIterable, Identifiable {
    case center
    case leading

    var id: String { rawValue }

    var title: String {
        switch self {
        case .center:
            AppText.captionAlignmentCenter
        case .leading:
            AppText.captionAlignmentLeading
        }
    }

    var systemImage: String {
        switch self {
        case .center:
            "text.aligncenter"
        case .leading:
            "text.alignleft"
        }
    }

    var textAlignment: TextAlignment {
        switch self {
        case .center:
            .center
        case .leading:
            .leading
        }
    }

    var horizontalAlignment: HorizontalAlignment {
        switch self {
        case .center:
            .center
        case .leading:
            .leading
        }
    }

    func frameAlignment(vertical: VerticalAlignment) -> Alignment {
        Alignment(horizontal: horizontalAlignment, vertical: vertical)
    }
}

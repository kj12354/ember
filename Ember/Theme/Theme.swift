import SwiftUI

enum EmberSpacing {
    static let xxs: CGFloat = 4
    static let xs: CGFloat = 8
    static let sm: CGFloat = 12
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
    static let xxl: CGFloat = 48
    static let screen: CGFloat = 28

    static let cardRadius: CGFloat = 20
    static let recordButtonSize: CGFloat = 88
}

enum EmberTypography {
    /// Screen titles — SF Pro, calm and large.
    static func display() -> Font {
        .system(size: 34, weight: .medium, design: .default)
    }

    static func title() -> Font {
        .system(size: 22, weight: .medium, design: .default)
    }

    static func caption() -> Font {
        .system(size: 13, weight: .medium, design: .default)
    }

    /// Entry and reflection body — New York serif, literary.
    static func serifBody() -> Font {
        .system(.body, design: .serif)
    }

    static func serifPrompt() -> Font {
        .system(size: 26, weight: .regular, design: .serif)
    }

    static func serifDetail() -> Font {
        .system(size: 18, weight: .regular, design: .serif)
    }
}

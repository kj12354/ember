import SwiftUI

extension Color {
    /// Warm espresso-ink. Never pure black.
    static let emberBackground = Color(hex: 0x17130F)
    static let emberBackgroundSecondary = Color(hex: 0x1B1512)

    /// One step lighter and slightly warmer than the base.
    static let emberSurface = Color(hex: 0x241C17)
    static let emberSurfaceElevated = Color(hex: 0x2E241C)

    /// Amber glow — record button, active states, the call accent. Use sparingly.
    static let emberAccent = Color(hex: 0xE8A15C)
    static let emberAccentDeep = Color(hex: 0xD98247)

    static let emberTextPrimary = Color(hex: 0xEDE6DC)
    static let emberTextSecondary = Color(hex: 0xB8A99A)
    static let emberTextTertiary = Color(hex: 0x8A7A6C)

    static let emberHairline = Color(hex: 0xEDE6DC).opacity(0.08)

    init(hex: UInt32, opacity: Double = 1) {
        let r = Double((hex >> 16) & 0xFF) / 255
        let g = Double((hex >> 8) & 0xFF) / 255
        let b = Double(hex & 0xFF) / 255
        self.init(.sRGB, red: r, green: g, blue: b, opacity: opacity)
    }
}

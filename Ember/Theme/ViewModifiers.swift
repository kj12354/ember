import SwiftUI

struct EmberScreenBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background {
                ZStack {
                    Color.emberBackground
                    RadialGradient(
                        colors: [
                            Color.emberAccent.opacity(0.07),
                            Color.clear
                        ],
                        center: .bottom,
                        startRadius: 20,
                        endRadius: 420
                    )
                    .offset(y: 80)
                    VignetteOverlay()
                }
                .ignoresSafeArea()
            }
    }
}

struct EmberCardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.emberSurface)
            .clipShape(RoundedRectangle(cornerRadius: EmberSpacing.cardRadius, style: .continuous))
            .shadow(color: Color.black.opacity(0.28), radius: 18, x: 0, y: 10)
    }
}

struct EmberGlow: ViewModifier {
    var isActive: Bool
    var radius: CGFloat = 48

    func body(content: Content) -> some View {
        content
            .background {
                Circle()
                    .fill(Color.emberAccent.opacity(isActive ? 0.45 : 0.22))
                    .blur(radius: radius)
                    .scaleEffect(isActive ? 1.18 : 1.0)
            }
    }
}

private struct VignetteOverlay: View {
    var body: some View {
        RadialGradient(
            colors: [
                Color.clear,
                Color.emberBackground.opacity(0.55)
            ],
            center: .center,
            startRadius: 140,
            endRadius: 520
        )
        .allowsHitTesting(false)
    }
}

extension View {
    func emberScreenBackground() -> some View {
        modifier(EmberScreenBackground())
    }

    func emberCard() -> some View {
        modifier(EmberCardStyle())
    }

    func emberGlow(isActive: Bool, radius: CGFloat = 48) -> some View {
        modifier(EmberGlow(isActive: isActive, radius: radius))
    }
}

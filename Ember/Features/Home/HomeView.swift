import SwiftData
import SwiftUI

struct HomeView: View {
    @Query(sort: \JournalEntry.createdAt, order: .reverse) private var entries: [JournalEntry]
    @State private var model = HomeViewModel()
    @State private var glowBreath = false

    var body: some View {
        let dates = entries.map(\.createdAt)
        let streak = model.streak(from: dates)
        let wroteToday = model.wroteToday(from: dates)

        VStack(alignment: .leading, spacing: 0) {
            header
            Spacer(minLength: EmberSpacing.lg)
            greetingBlock(wroteToday: wroteToday)
            Spacer()
            recordCluster
            Spacer(minLength: EmberSpacing.xxl)
            streakPeek(streak: streak, wroteToday: wroteToday)
        }
        .padding(.horizontal, EmberSpacing.screen)
        .padding(.top, EmberSpacing.md)
        .padding(.bottom, EmberSpacing.lg)
        .emberScreenBackground()
        .onAppear {
            withAnimation(.easeInOut(duration: 2.8).repeatForever(autoreverses: true)) {
                glowBreath = true
            }
        }
    }

    private var header: some View {
        HStack {
            Text(model.now, format: .dateTime.weekday(.wide).month(.wide).day())
                .font(EmberTypography.caption())
                .foregroundStyle(Color.emberTextTertiary)
                .textCase(.uppercase)
                .tracking(1.2)
            Spacer()
        }
    }

    private func greetingBlock(wroteToday: Bool) -> some View {
        VStack(alignment: .leading, spacing: EmberSpacing.md) {
            Text(model.greeting)
                .font(EmberTypography.display())
                .foregroundStyle(Color.emberTextPrimary)

            if wroteToday {
                Text("You've already written today. Come back if more wants out.")
                    .font(EmberTypography.serifPrompt())
                    .foregroundStyle(Color.emberTextSecondary)
                    .lineSpacing(6)
                    .fixedSize(horizontal: false, vertical: true)
            } else {
                Text(model.prompt)
                    .font(EmberTypography.serifPrompt())
                    .foregroundStyle(Color.emberTextSecondary)
                    .lineSpacing(6)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var recordCluster: some View {
        VStack(spacing: EmberSpacing.md) {
            ZStack {
                Circle()
                    .fill(Color.emberAccent.opacity(glowBreath ? 0.28 : 0.14))
                    .frame(width: 168, height: 168)
                    .blur(radius: 36)
                    .scaleEffect(glowBreath ? 1.08 : 0.92)

                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.emberAccent, Color.emberAccentDeep],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: EmberSpacing.recordButtonSize, height: EmberSpacing.recordButtonSize)
                    .shadow(color: Color.emberAccent.opacity(0.35), radius: 16, y: 8)

                Image(systemName: "mic.fill")
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundStyle(Color.emberBackground)
            }
            .frame(maxWidth: .infinity)
            .accessibilityLabel("Record an entry")
            .accessibilityHint("Recording arrives in the next milestone.")

            Text("Tap to begin a note")
                .font(EmberTypography.caption())
                .foregroundStyle(Color.emberTextTertiary)
                .tracking(0.4)
        }
    }

    private func streakPeek(streak: Int, wroteToday: Bool) -> some View {
        HStack(spacing: EmberSpacing.xs) {
            Image(systemName: "flame.fill")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(Color.emberAccent.opacity(streak > 0 ? 1 : 0.55))
            Text(streakLabel(streak, wroteToday: wroteToday))
                .font(EmberTypography.caption())
                .foregroundStyle(Color.emberTextSecondary)
        }
        .padding(.horizontal, EmberSpacing.md)
        .padding(.vertical, EmberSpacing.sm)
        .background(Color.emberSurface)
        .clipShape(Capsule())
        .frame(maxWidth: .infinity)
    }

    private func streakLabel(_ streak: Int, wroteToday: Bool) -> String {
        if streak == 0 {
            return wroteToday ? "A beginning." : "Your streak begins with one note."
        }
        if streak == 1 {
            return "1 day. Quietly underway."
        }
        return "\(streak) days in a row."
    }
}

#Preview {
    HomeView()
        .modelContainer(for: JournalEntry.self, inMemory: true)
        .preferredColorScheme(.dark)
}

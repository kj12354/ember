import SwiftData
import SwiftUI

@main
struct EmberApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(\.appServices, .live)
        }
        .modelContainer(for: JournalEntry.self)
    }
}

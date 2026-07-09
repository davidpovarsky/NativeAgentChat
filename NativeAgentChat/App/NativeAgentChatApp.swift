import SwiftUI

@main
struct NativeAgentChatApp: App {
    @StateObject private var settings = AppSettings()
    @StateObject private var engine = ChatEngine()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(settings)
                .environmentObject(engine)
                .task {
                    engine.attach(settings: settings)
                }
        }
    }
}

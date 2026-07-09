import SwiftUI

struct RootView: View {
    @State private var selection: SidebarItem? = .chat

    var body: some View {
        NavigationSplitView {
            List(SidebarItem.allCases, selection: $selection) { item in
                Label(item.title, systemImage: item.systemImage)
                    .tag(item)
            }
            .navigationTitle("Native Agent")
        } detail: {
            switch selection ?? .chat {
            case .chat:
                ChatView()
            case .schema:
                SchemaView()
            case .settings:
                SettingsView()
            }
        }
    }
}

enum SidebarItem: String, CaseIterable, Identifiable {
    case chat
    case schema
    case settings

    var id: String { rawValue }

    var title: String {
        switch self {
        case .chat: return "Chat"
        case .schema: return "UI Schema"
        case .settings: return "Settings"
        }
    }

    var systemImage: String {
        switch self {
        case .chat: return "bubble.left.and.bubble.right"
        case .schema: return "curlybraces.square"
        case .settings: return "gearshape"
        }
    }
}

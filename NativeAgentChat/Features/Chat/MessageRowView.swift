import SwiftUI

struct MessageRowView: View {
    let message: ChatMessage
    let onAction: (ToolAction) -> Void

    var body: some View {
        Section {
            ForEach(Array(message.components.enumerated()), id: \.offset) { _, component in
                ComponentRenderer(component: component, onAction: onAction)
            }
        } header: {
            Label(title, systemImage: icon)
        } footer: {
            Text(message.createdAt.formatted(date: .omitted, time: .shortened))
        }
    }

    private var title: String {
        switch message.role {
        case .user: return "You"
        case .assistant: return "Assistant"
        case .system: return "System"
        case .tool: return "Tool"
        }
    }

    private var icon: String {
        switch message.role {
        case .user: return "person.crop.circle"
        case .assistant: return "sparkles"
        case .system: return "gear"
        case .tool: return "wrench.and.screwdriver"
        }
    }
}

import Foundation

struct ChatMessage: Identifiable, Codable, Sendable {
    let id: UUID
    let role: ChatRole
    var components: [ChatComponent]
    let createdAt: Date

    init(id: UUID = UUID(), role: ChatRole, components: [ChatComponent], createdAt: Date = Date()) {
        self.id = id
        self.role = role
        self.components = components
        self.createdAt = createdAt
    }

    static func userText(_ text: String) -> ChatMessage {
        ChatMessage(role: .user, components: [.text(TextComponent(content: text))])
    }

    static func assistantText(_ text: String) -> ChatMessage {
        ChatMessage(role: .assistant, components: [.text(TextComponent(content: text))])
    }
}

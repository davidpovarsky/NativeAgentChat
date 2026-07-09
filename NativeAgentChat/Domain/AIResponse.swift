import Foundation

struct AIResponse: Codable, Sendable {
    var components: [ChatComponent]
    var actions: [ToolAction]

    init(components: [ChatComponent], actions: [ToolAction] = []) {
        self.components = components
        self.actions = actions
    }
}

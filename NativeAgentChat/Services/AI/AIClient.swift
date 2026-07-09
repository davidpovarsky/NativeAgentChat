import Foundation

protocol AIClient: Sendable {
    func complete(messages: [ChatMessage], settings: AppSettings.Snapshot) async throws -> AIResponse
}

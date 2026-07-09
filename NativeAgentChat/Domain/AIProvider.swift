import Foundation

enum AIProvider: String, CaseIterable, Identifiable, Codable, Sendable {
    case demo
    case openAI
    case anthropic

    var id: String { rawValue }

    var title: String {
        switch self {
        case .demo: return "Demo / Offline"
        case .openAI: return "OpenAI-compatible"
        case .anthropic: return "Claude / Anthropic"
        }
    }
}

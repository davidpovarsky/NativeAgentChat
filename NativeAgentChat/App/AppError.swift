import Foundation

enum AppError: LocalizedError {
    case missingAPIKey(String)
    case invalidURL(String)
    case invalidResponse
    case emptyModelResponse
    case unsupportedAction(String)
    case actionBlocked(String)
    case scriptExecutionFailed(String)

    var errorDescription: String? {
        switch self {
        case .missingAPIKey(let provider):
            return "Missing API key for \(provider). Add it in Settings."
        case .invalidURL(let value):
            return "Invalid URL: \(value)"
        case .invalidResponse:
            return "The server returned an invalid response."
        case .emptyModelResponse:
            return "The model returned an empty response."
        case .unsupportedAction(let action):
            return "Unsupported action: \(action)"
        case .actionBlocked(let reason):
            return "Action blocked: \(reason)"
        case .scriptExecutionFailed(let message):
            return "Script execution failed: \(message)"
        }
    }
}

import Foundation
import JavaScriptCore

struct JavaScriptSandbox: Sendable {
    func evaluate(_ code: String) throws -> String {
        let trimmed = code.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { throw AppError.scriptExecutionFailed("Empty script.") }

        let blockedTerms = ["XMLHttpRequest", "fetch", "webkit", "UIApplication", "FileManager"]
        if let blocked = blockedTerms.first(where: { trimmed.localizedCaseInsensitiveContains($0) }) {
            throw AppError.actionBlocked("Blocked token in script: \(blocked)")
        }

        guard let context = JSContext() else {
            throw AppError.scriptExecutionFailed("Unable to create JavaScript context.")
        }

        var exceptionMessage: String?
        context.exceptionHandler = { _, exception in
            exceptionMessage = exception?.toString()
        }

        let result = context.evaluateScript(trimmed)

        if let exceptionMessage {
            throw AppError.scriptExecutionFailed(exceptionMessage)
        }

        return result?.toString() ?? "Script completed with no return value."
    }
}

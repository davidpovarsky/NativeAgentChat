import Foundation
import UIKit

struct ToolRouter: Sendable {
    func execute(_ action: ToolAction, settings: AppSettings.Snapshot) async throws -> String? {
        switch action.name {
        case "openURL":
            return try await openURL(action.parameters["url"])
        case "searchSefaria":
            return try await searchSefaria(action.parameters["query"])
        case "runShortcut":
            return try await runShortcut(name: action.parameters["name"], input: action.parameters["input"])
        case "saveNote":
            return try saveNote(title: action.parameters["title"], body: action.parameters["body"])
        case "runJavaScript":
            guard settings.allowLocalJavaScript else {
                throw AppError.actionBlocked("Local JavaScript is disabled in Settings.")
            }
            return try JavaScriptSandbox().evaluate(action.parameters["code"] ?? "")
        default:
            throw AppError.unsupportedAction(action.name)
        }
    }

    @MainActor
    private func openURL(_ rawURL: String?) async throws -> String? {
        guard let rawURL, let url = URL(string: rawURL) else { throw AppError.invalidURL(rawURL ?? "") }
        UIApplication.shared.open(url)
        return "Opened URL: \(url.absoluteString)"
    }

    @MainActor
    private func searchSefaria(_ query: String?) async throws -> String? {
        let query = query?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard !query.isEmpty else { throw AppError.actionBlocked("Missing Sefaria query.") }
        let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        guard let url = URL(string: "https://www.sefaria.org.il/search?q=\(encoded)") else { throw AppError.invalidURL(query) }
        UIApplication.shared.open(url)
        return "Opened Sefaria search for: \(query)"
    }

    @MainActor
    private func runShortcut(name: String?, input: String?) async throws -> String? {
        guard let name, !name.isEmpty else { throw AppError.actionBlocked("Missing Shortcut name.") }
        var components = URLComponents(string: "shortcuts://run-shortcut")
        components?.queryItems = [URLQueryItem(name: "name", value: name)]
        if let input, !input.isEmpty {
            components?.queryItems?.append(URLQueryItem(name: "input", value: input))
        }
        guard let url = components?.url else { throw AppError.invalidURL(name) }
        UIApplication.shared.open(url)
        return "Requested Shortcut: \(name)"
    }

    private func saveNote(title: String?, body: String?) throws -> String? {
        let safeTitle = (title?.isEmpty == false ? title! : "Note").replacingOccurrences(of: "/", with: "-")
        let body = body ?? ""
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let url = directory.appending(path: "\(safeTitle).txt")
        try body.write(to: url, atomically: true, encoding: .utf8)
        return "Saved note: \(url.lastPathComponent)"
    }
}

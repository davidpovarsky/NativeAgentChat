import Foundation

struct ToolAction: Codable, Sendable, Hashable, Identifiable {
    var id: String { name + parameters.description }
    var name: String
    var parameters: [String: String]

    init(name: String, parameters: [String: String] = [:]) {
        self.name = name
        self.parameters = parameters
    }

    static func openURL(_ url: String) -> ToolAction {
        ToolAction(name: "openURL", parameters: ["url": url])
    }

    static func searchSefaria(_ query: String) -> ToolAction {
        ToolAction(name: "searchSefaria", parameters: ["query": query])
    }

    static func runJavaScript(_ code: String) -> ToolAction {
        ToolAction(name: "runJavaScript", parameters: ["code": code])
    }

    static func runShortcut(name: String, input: String? = nil) -> ToolAction {
        var parameters = ["name": name]
        if let input { parameters["input"] = input }
        return ToolAction(name: "runShortcut", parameters: parameters)
    }

    static func saveNote(title: String, body: String) -> ToolAction {
        ToolAction(name: "saveNote", parameters: ["title": title, "body": body])
    }
}

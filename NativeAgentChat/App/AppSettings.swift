import Foundation

@MainActor
final class AppSettings: ObservableObject {
    @Published var selectedProvider: AIProvider {
        didSet { defaults.set(selectedProvider.rawValue, forKey: Keys.selectedProvider) }
    }

    @Published var openAIAPIKey: String {
        didSet { defaults.set(openAIAPIKey, forKey: Keys.openAIAPIKey) }
    }

    @Published var openAIBaseURL: String {
        didSet { defaults.set(openAIBaseURL, forKey: Keys.openAIBaseURL) }
    }

    @Published var openAIModel: String {
        didSet { defaults.set(openAIModel, forKey: Keys.openAIModel) }
    }

    @Published var anthropicAPIKey: String {
        didSet { defaults.set(anthropicAPIKey, forKey: Keys.anthropicAPIKey) }
    }

    @Published var anthropicBaseURL: String {
        didSet { defaults.set(anthropicBaseURL, forKey: Keys.anthropicBaseURL) }
    }

    @Published var anthropicModel: String {
        didSet { defaults.set(anthropicModel, forKey: Keys.anthropicModel) }
    }

    @Published var allowLocalJavaScript: Bool {
        didSet { defaults.set(allowLocalJavaScript, forKey: Keys.allowLocalJavaScript) }
    }

    @Published var requireConfirmationBeforeActions: Bool {
        didSet { defaults.set(requireConfirmationBeforeActions, forKey: Keys.requireConfirmationBeforeActions) }
    }

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        let providerRaw = defaults.string(forKey: Keys.selectedProvider) ?? AIProvider.demo.rawValue
        self.selectedProvider = AIProvider(rawValue: providerRaw) ?? .demo
        self.openAIAPIKey = defaults.string(forKey: Keys.openAIAPIKey) ?? ""
        self.openAIBaseURL = defaults.string(forKey: Keys.openAIBaseURL) ?? "https://api.openai.com/v1"
        self.openAIModel = defaults.string(forKey: Keys.openAIModel) ?? "gpt-4o-mini"
        self.anthropicAPIKey = defaults.string(forKey: Keys.anthropicAPIKey) ?? ""
        self.anthropicBaseURL = defaults.string(forKey: Keys.anthropicBaseURL) ?? "https://api.anthropic.com"
        self.anthropicModel = defaults.string(forKey: Keys.anthropicModel) ?? "claude-3-5-sonnet-latest"
        self.allowLocalJavaScript = defaults.object(forKey: Keys.allowLocalJavaScript) as? Bool ?? false
        self.requireConfirmationBeforeActions = defaults.object(forKey: Keys.requireConfirmationBeforeActions) as? Bool ?? true
    }

    struct Snapshot: Sendable {
        let selectedProvider: AIProvider
        let openAIAPIKey: String
        let openAIBaseURL: String
        let openAIModel: String
        let anthropicAPIKey: String
        let anthropicBaseURL: String
        let anthropicModel: String
        let allowLocalJavaScript: Bool
        let requireConfirmationBeforeActions: Bool
    }

    func snapshot() -> Snapshot {
        Snapshot(
            selectedProvider: selectedProvider,
            openAIAPIKey: openAIAPIKey,
            openAIBaseURL: openAIBaseURL,
            openAIModel: openAIModel,
            anthropicAPIKey: anthropicAPIKey,
            anthropicBaseURL: anthropicBaseURL,
            anthropicModel: anthropicModel,
            allowLocalJavaScript: allowLocalJavaScript,
            requireConfirmationBeforeActions: requireConfirmationBeforeActions
        )
    }

    private enum Keys {
        static let selectedProvider = "selectedProvider"
        static let openAIAPIKey = "openAIAPIKey"
        static let openAIBaseURL = "openAIBaseURL"
        static let openAIModel = "openAIModel"
        static let anthropicAPIKey = "anthropicAPIKey"
        static let anthropicBaseURL = "anthropicBaseURL"
        static let anthropicModel = "anthropicModel"
        static let allowLocalJavaScript = "allowLocalJavaScript"
        static let requireConfirmationBeforeActions = "requireConfirmationBeforeActions"
    }
}

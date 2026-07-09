import Foundation

@MainActor
final class ChatEngine: ObservableObject {
    @Published var messages: [ChatMessage] = [
        .assistantText("שלום. זהו שלד נייטיבי ל־AI Chat עם Generative UI. נסה לכתוב: ‘תציג גרף’, ‘חפש בספריא ברכות’, או ‘תן סקריפט JavaScript’.")
    ]
    @Published var draftText: String = ""
    @Published var isSending: Bool = false
    @Published var lastError: String?
    @Published var pendingAction: ToolAction?

    private weak var settings: AppSettings?
    private let toolRouter = ToolRouter()

    func attach(settings: AppSettings) {
        self.settings = settings
    }

    func sendCurrentDraft() async {
        let text = draftText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty, !isSending else { return }

        draftText = ""
        messages.append(.userText(text))
        await sendToModel()
    }

    func run(action: ToolAction) async {
        guard let settings else { return }
        let snapshot = settings.snapshot()

        if snapshot.requireConfirmationBeforeActions {
            pendingAction = action
            return
        }

        await execute(action: action, settings: snapshot)
    }

    func confirmPendingAction() async {
        guard let settings, let pendingAction else { return }
        let action = pendingAction
        self.pendingAction = nil
        await execute(action: action, settings: settings.snapshot())
    }

    func cancelPendingAction() {
        pendingAction = nil
    }

    private func sendToModel() async {
        guard let settings else { return }
        isSending = true
        lastError = nil
        defer { isSending = false }

        do {
            let snapshot = settings.snapshot()
            let client = client(for: snapshot.selectedProvider)
            let response = try await client.complete(messages: messages, settings: snapshot)
            messages.append(ChatMessage(role: .assistant, components: response.components))

            for action in response.actions {
                await run(action: action)
            }
        } catch {
            lastError = error.localizedDescription
            messages.append(.assistantText("שגיאה: \(error.localizedDescription)"))
        }
    }

    private func execute(action: ToolAction, settings: AppSettings.Snapshot) async {
        do {
            let result = try await toolRouter.execute(action, settings: settings)
            if let result {
                messages.append(ChatMessage(role: .tool, components: [.text(TextComponent(content: result))]))
            }
        } catch {
            lastError = error.localizedDescription
            messages.append(.assistantText("הפעולה נכשלה: \(error.localizedDescription)"))
        }
    }

    private func client(for provider: AIProvider) -> AIClient {
        switch provider {
        case .demo:
            return DemoAIClient()
        case .openAI:
            return OpenAIClient()
        case .anthropic:
            return AnthropicClient()
        }
    }
}

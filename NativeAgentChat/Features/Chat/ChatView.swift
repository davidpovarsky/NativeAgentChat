import SwiftUI

struct ChatView: View {
    @EnvironmentObject private var engine: ChatEngine

    var body: some View {
        List {
            ForEach(engine.messages) { message in
                MessageRowView(message: message) { action in
                    Task { await engine.run(action: action) }
                }
                .listRowSeparator(.hidden)
            }

            if engine.isSending {
                ProgressView("Thinking")
            }
        }
        .navigationTitle("AI Chat")
        .safeAreaInset(edge: .bottom) {
            ComposerView(text: $engine.draftText, isSending: engine.isSending) {
                Task { await engine.sendCurrentDraft() }
            }
        }
        .alert("Run action?", isPresented: Binding(
            get: { engine.pendingAction != nil },
            set: { if !$0 { engine.cancelPendingAction() } }
        )) {
            Button("Cancel", role: .cancel) { engine.cancelPendingAction() }
            Button("Run") { Task { await engine.confirmPendingAction() } }
        } message: {
            if let action = engine.pendingAction {
                Text("\(action.name)\n\(action.parameters.description)")
            }
        }
    }
}

import SwiftUI

struct ScriptBlockView: View {
    let component: ScriptBlockComponent
    let onAction: (ToolAction) -> Void

    var body: some View {
        GroupBox(component.language) {
            Text(component.code)
                .font(.system(.footnote, design: .monospaced))
                .textSelection(.enabled)

            if let action = component.action {
                Button("Run script", systemImage: "play.fill") {
                    onAction(action)
                }
                .buttonStyle(.bordered)
            }
        }
    }
}

import SwiftUI

struct SourceCardView: View {
    let component: SourceCardComponent
    let onAction: (ToolAction) -> Void

    var body: some View {
        GroupBox(component.title) {
            LabeledContent("Reference", value: component.reference)

            Text(component.body)
                .textSelection(.enabled)

            ForEach(component.actions) { action in
                Button(action.name, systemImage: icon(for: action.name)) {
                    onAction(action)
                }
                .buttonStyle(.bordered)
            }
        }
    }

    private func icon(for actionName: String) -> String {
        switch actionName {
        case "openURL": return "arrow.up.right.square"
        case "searchSefaria": return "magnifyingglass"
        case "runShortcut": return "wand.and.stars"
        case "runJavaScript": return "play.fill"
        default: return "bolt"
        }
    }
}

import SwiftUI

struct ActionButtonView: View {
    let component: ActionButtonComponent
    let onAction: (ToolAction) -> Void

    var body: some View {
        Button(component.label, systemImage: component.systemImage ?? "bolt") {
            onAction(component.action)
        }
        .buttonStyle(.borderedProminent)
    }
}

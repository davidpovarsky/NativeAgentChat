import SwiftUI

struct InputFormView: View {
    let component: InputFormComponent
    let onAction: (ToolAction) -> Void
    @State private var values: [String: String] = [:]

    var body: some View {
        GroupBox(component.title) {
            ForEach(component.fields) { field in
                TextField(
                    field.placeholder ?? field.label,
                    text: Binding(
                        get: { values[field.name] ?? field.value ?? "" },
                        set: { values[field.name] = $0 }
                    )
                )
                .textFieldStyle(.roundedBorder)
            }

            Button("Submit", systemImage: "checkmark.circle") {
                var action = component.submitAction
                for (key, value) in values {
                    action.parameters[key] = value
                }
                onAction(action)
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

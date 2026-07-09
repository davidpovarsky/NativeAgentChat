import SwiftUI

struct SchemaView: View {
    var body: some View {
        List {
            Section("Architecture") {
                LabeledContent("Model Adapter", value: "OpenAI / Claude / Demo")
                LabeledContent("Contract", value: "JSON components")
                LabeledContent("Renderer", value: "SwiftUI native views")
                LabeledContent("Actions", value: "ToolRouter")
            }

            Section("Supported UI components") {
                ForEach(componentNames, id: \.self) { name in
                    Text(name)
                }
            }

            Section("System Prompt") {
                Text(PromptFactory.systemPrompt)
                    .font(.system(.footnote, design: .monospaced))
                    .textSelection(.enabled)
            }
        }
        .navigationTitle("UI Schema")
    }

    private var componentNames: [String] {
        ["text", "metricCard", "chart", "resultList", "sourceCard", "actionButton", "scriptBlock", "inputForm"]
    }
}

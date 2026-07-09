import SwiftUI
import Charts

struct ComponentRenderer: View {
    let component: ChatComponent
    let onAction: (ToolAction) -> Void

    var body: some View {
        switch component {
        case .text(let component):
            Text(component.content)
                .textSelection(.enabled)

        case .metricCard(let component):
            MetricCardView(component: component)

        case .chart(let component):
            ChartCardView(component: component)

        case .resultList(let component):
            ResultListView(component: component, onAction: onAction)

        case .sourceCard(let component):
            SourceCardView(component: component, onAction: onAction)

        case .actionButton(let component):
            ActionButtonView(component: component, onAction: onAction)

        case .scriptBlock(let component):
            ScriptBlockView(component: component, onAction: onAction)

        case .inputForm(let component):
            InputFormView(component: component, onAction: onAction)
        }
    }
}

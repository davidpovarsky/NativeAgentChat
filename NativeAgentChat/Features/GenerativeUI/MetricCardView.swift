import SwiftUI

struct MetricCardView: View {
    let component: MetricCardComponent

    var body: some View {
        GroupBox(component.title) {
            LabeledContent("Value", value: component.value)
                .font(.title3)

            if let trend = component.trend {
                LabeledContent("Trend", value: trend.formatted(.percent.precision(.fractionLength(0...1))))
            }

            if let subtitle = component.subtitle {
                Text(subtitle)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

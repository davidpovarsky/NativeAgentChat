import SwiftUI
import Charts

struct ChartCardView: View {
    let component: ChartComponent

    var body: some View {
        GroupBox(component.title) {
            if let subtitle = component.subtitle {
                Text(subtitle)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Chart(component.points) { point in
                BarMark(
                    x: .value("Label", point.label),
                    y: .value("Value", point.value)
                )
            }
            .frame(minHeight: 180)
            .chartYAxis {
                AxisMarks(position: .leading)
            }
        }
    }
}

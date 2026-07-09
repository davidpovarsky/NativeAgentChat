import SwiftUI

struct ResultListView: View {
    let component: ResultListComponent
    let onAction: (ToolAction) -> Void

    var body: some View {
        GroupBox(component.title) {
            ForEach(component.items) { item in
                ResultItemView(item: item, onAction: onAction)
            }
        }
    }
}

private struct ResultItemView: View {
    let item: ResultItem
    let onAction: (ToolAction) -> Void

    var body: some View {
        if let url = item.url, let linkURL = URL(string: url) {
            Link(destination: linkURL) {
                row
            }
        } else if let action = item.action {
            Button(action: { onAction(action) }) {
                row
            }
        } else {
            row
        }
    }

    private var row: some View {
        LabeledContent {
            if let subtitle = item.subtitle {
                Text(subtitle)
                    .foregroundStyle(.secondary)
            }
        } label: {
            Text(item.title)
        }
        .padding(.vertical, 4)
    }
}

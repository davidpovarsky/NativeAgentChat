import SwiftUI

struct ComposerView: View {
    @Binding var text: String
    let isSending: Bool
    let send: () -> Void

    var body: some View {
        GroupBox {
            Grid(alignment: .leading, horizontalSpacing: 12, verticalSpacing: 12) {
                GridRow {
                    TextField("Write a message", text: $text, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .lineLimit(1...5)

                    Button("Send", systemImage: "paperplane.fill", action: send)
                        .buttonStyle(.borderedProminent)
                        .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isSending)
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(.regularMaterial)
    }
}

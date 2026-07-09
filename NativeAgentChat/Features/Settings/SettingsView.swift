import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var settings: AppSettings

    var body: some View {
        Form {
            Section("Model") {
                Picker("Provider", selection: $settings.selectedProvider) {
                    ForEach(AIProvider.allCases) { provider in
                        Text(provider.title).tag(provider)
                    }
                }
            }

            Section("OpenAI-compatible") {
                TextField("Base URL", text: $settings.openAIBaseURL)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                SecureField("API Key", text: $settings.openAIAPIKey)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                TextField("Model", text: $settings.openAIModel)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            }

            Section("Claude / Anthropic") {
                TextField("Base URL", text: $settings.anthropicBaseURL)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                SecureField("API Key", text: $settings.anthropicAPIKey)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                TextField("Model", text: $settings.anthropicModel)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            }

            Section("Local actions") {
                Toggle("Ask before running actions", isOn: $settings.requireConfirmationBeforeActions)
                Toggle("Allow local JavaScript", isOn: $settings.allowLocalJavaScript)
                Text("JavaScript is intentionally disabled by default. For production, replace free-form scripts with named, allow-listed actions wherever possible.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Settings")
    }
}

import Foundation

struct AnthropicClient: AIClient {
    func complete(messages: [ChatMessage], settings: AppSettings.Snapshot) async throws -> AIResponse {
        guard !settings.anthropicAPIKey.isEmpty else { throw AppError.missingAPIKey("Anthropic") }
        guard let base = URL(string: settings.anthropicBaseURL) else { throw AppError.invalidURL(settings.anthropicBaseURL) }

        let url = base.appending(path: "v1/messages")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(settings.anthropicAPIKey, forHTTPHeaderField: "x-api-key")
        request.setValue("2023-06-01", forHTTPHeaderField: "anthropic-version")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let payload = AnthropicRequest(
            model: settings.anthropicModel,
            maxTokens: 1800,
            system: PromptFactory.systemPrompt,
            messages: buildMessages(from: messages)
        )

        request.httpBody = try JSONEncoder.agent.encode(payload)

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
            let serverText = String(data: data, encoding: .utf8) ?? ""
            throw AppError.scriptExecutionFailed(serverText.isEmpty ? "Anthropic request failed." : serverText)
        }

        let decoded = try JSONDecoder.agent.decode(AnthropicResponse.self, from: data)
        let content = decoded.content.compactMap { block -> String? in
            switch block {
            case .text(let text): return text.text
            case .unknown: return nil
            }
        }.joined(separator: "\n")

        guard !content.isEmpty else { throw AppError.emptyModelResponse }
        return try AIResponseDecoder.decode(content)
    }

    private func buildMessages(from messages: [ChatMessage]) -> [AnthropicMessage] {
        messages.map { message in
            AnthropicMessage(role: message.role == .assistant ? "assistant" : "user", content: text(from: message))
        }
    }

    private func text(from message: ChatMessage) -> String {
        message.components.compactMap { component in
            if case .text(let text) = component { return text.content }
            return nil
        }.joined(separator: "\n")
    }
}

private struct AnthropicRequest: Encodable {
    let model: String
    let maxTokens: Int
    let system: String
    let messages: [AnthropicMessage]

    enum CodingKeys: String, CodingKey {
        case model
        case maxTokens = "max_tokens"
        case system
        case messages
    }
}

private struct AnthropicMessage: Codable {
    let role: String
    let content: String
}

private struct AnthropicResponse: Decodable {
    let content: [AnthropicContentBlock]
}

private enum AnthropicContentBlock: Decodable {
    case text(TextBlock)
    case unknown

    struct TextBlock: Decodable {
        let text: String
    }

    private enum CodingKeys: String, CodingKey { case type }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        if type == "text" {
            self = .text(try TextBlock(from: decoder))
        } else {
            self = .unknown
        }
    }
}

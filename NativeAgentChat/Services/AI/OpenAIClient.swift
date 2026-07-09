import Foundation

struct OpenAIClient: AIClient {
    func complete(messages: [ChatMessage], settings: AppSettings.Snapshot) async throws -> AIResponse {
        guard !settings.openAIAPIKey.isEmpty else { throw AppError.missingAPIKey("OpenAI-compatible") }
        guard let base = URL(string: settings.openAIBaseURL) else { throw AppError.invalidURL(settings.openAIBaseURL) }

        let url = base.appending(path: "chat/completions")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(settings.openAIAPIKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let payload = OpenAIChatRequest(
            model: settings.openAIModel,
            messages: buildMessages(from: messages),
            responseFormat: OpenAIResponseFormat(type: "json_object"),
            temperature: 0.2
        )

        request.httpBody = try JSONEncoder.agent.encode(payload)

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
            let serverText = String(data: data, encoding: .utf8) ?? ""
            throw AppError.scriptExecutionFailed(serverText.isEmpty ? "OpenAI-compatible request failed." : serverText)
        }

        let decoded = try JSONDecoder.agent.decode(OpenAIChatResponse.self, from: data)
        guard let content = decoded.choices.first?.message.content, !content.isEmpty else {
            throw AppError.emptyModelResponse
        }

        return try AIResponseDecoder.decode(content)
    }

    private func buildMessages(from messages: [ChatMessage]) -> [OpenAIMessage] {
        var output = [OpenAIMessage(role: "system", content: PromptFactory.systemPrompt)]
        output.append(contentsOf: messages.map { message in
            OpenAIMessage(role: message.role == .assistant ? "assistant" : "user", content: text(from: message))
        })
        return output
    }

    private func text(from message: ChatMessage) -> String {
        message.components.compactMap { component in
            if case .text(let text) = component { return text.content }
            return nil
        }.joined(separator: "\n")
    }
}

private struct OpenAIChatRequest: Encodable {
    let model: String
    let messages: [OpenAIMessage]
    let responseFormat: OpenAIResponseFormat
    let temperature: Double

    enum CodingKeys: String, CodingKey {
        case model
        case messages
        case responseFormat = "response_format"
        case temperature
    }
}

private struct OpenAIMessage: Codable {
    let role: String
    let content: String
}

private struct OpenAIResponseFormat: Encodable {
    let type: String
}

private struct OpenAIChatResponse: Decodable {
    let choices: [Choice]

    struct Choice: Decodable {
        let message: Message
    }

    struct Message: Decodable {
        let content: String?
    }
}

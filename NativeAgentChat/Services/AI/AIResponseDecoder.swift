import Foundation

enum AIResponseDecoder {
    static func decode(_ rawText: String) throws -> AIResponse {
        let trimmed = rawText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { throw AppError.emptyModelResponse }

        if let data = trimmed.data(using: .utf8), let decoded = try? JSONDecoder.agent.decode(AIResponse.self, from: data) {
            return decoded
        }

        if let json = extractFirstJSONObject(from: trimmed), let data = json.data(using: .utf8), let decoded = try? JSONDecoder.agent.decode(AIResponse.self, from: data) {
            return decoded
        }

        return AIResponse(components: [.text(TextComponent(content: trimmed))])
    }

    private static func extractFirstJSONObject(from text: String) -> String? {
        guard let start = text.firstIndex(of: "{") else { return nil }
        var depth = 0
        var inString = false
        var isEscaped = false

        for index in text[start...].indices {
            let character = text[index]

            if isEscaped {
                isEscaped = false
                continue
            }

            if character == "\\" {
                isEscaped = true
                continue
            }

            if character == "\"" {
                inString.toggle()
                continue
            }

            guard !inString else { continue }

            if character == "{" { depth += 1 }
            if character == "}" { depth -= 1 }

            if depth == 0 {
                return String(text[start...index])
            }
        }

        return nil
    }
}

extension JSONDecoder {
    static var agent: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}

extension JSONEncoder {
    static var agent: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }
}

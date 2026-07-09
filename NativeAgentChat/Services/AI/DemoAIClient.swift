import Foundation

struct DemoAIClient: AIClient {
    func complete(messages: [ChatMessage], settings: AppSettings.Snapshot) async throws -> AIResponse {
        let lastText = messages.last?.components.compactMap { component -> String? in
            if case .text(let text) = component { return text.content }
            return nil
        }.joined(separator: "\n") ?? ""

        let normalized = lastText.lowercased()

        if normalized.contains("גרף") || normalized.contains("chart") || normalized.contains("נתונים") {
            return AIResponse(components: [
                .text(TextComponent(content: "הנה דוגמה לרכיב UI חי שחוזר מהמודל כ־JSON ומרונדר נייטיבית עם Swift Charts.")),
                .chart(ChartComponent(
                    title: "דוגמת נתונים",
                    subtitle: "רכיב chart מתוך קטלוג ה־UI",
                    points: [
                        ChartPoint(label: "א׳", value: 12),
                        ChartPoint(label: "ב׳", value: 19),
                        ChartPoint(label: "ג׳", value: 7),
                        ChartPoint(label: "ד׳", value: 15)
                    ]
                )),
                .metricCard(MetricCardComponent(title: "שינוי", value: "+24%", trend: 0.24, subtitle: "כרטיס מדד נייטיבי"))
            ])
        }

        if normalized.contains("sefaria") || normalized.contains("ספריא") || normalized.contains("אוצריא") || normalized.contains("גמרא") {
            let query = lastText.isEmpty ? "ברכות" : lastText
            return AIResponse(components: [
                .sourceCard(SourceCardComponent(
                    title: "דוגמת מקור",
                    reference: "Sefaria / Otzaria bridge",
                    body: "בגרסה אמיתית הפעולה searchSefaria תנותב לכלי שלך: API, SQLite מקומי, URL Scheme או MCP bridge.",
                    actions: [
                        .searchSefaria(query),
                        .openURL("https://www.sefaria.org.il/search?q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query)")
                    ]
                )),
                .actionButton(ActionButtonComponent(label: "חפש בספריא", systemImage: "magnifyingglass", action: .searchSefaria(query)))
            ])
        }

        if normalized.contains("script") || normalized.contains("סקריפט") || normalized.contains("javascript") {
            let code = """
            const values = [3, 7, 12, 2];
            values.reduce((sum, item) => sum + item, 0);
            """
            return AIResponse(components: [
                .text(TextComponent(content: "הנה דוגמה לסקריפט מקומי. ברירת המחדל חוסמת הרצה עד שתפעיל JavaScript בהגדרות.")),
                .scriptBlock(ScriptBlockComponent(language: "javascript", code: code, action: .runJavaScript(code))),
                .actionButton(ActionButtonComponent(label: "הרץ JavaScript מקומי", systemImage: "play.fill", action: .runJavaScript(code)))
            ])
        }

        return AIResponse(components: [
            .text(TextComponent(content: "השלד עובד במצב Demo. כתוב למשל: ‘תציג גרף’, ‘חפש בספריא ברכות’, או ‘תן סקריפט JavaScript’.")),
            .resultList(ResultListComponent(title: "מה כבר מחובר", items: [
                ResultItem(title: "Model Adapter", subtitle: "OpenAI-compatible, Anthropic, Demo", url: nil, action: nil),
                ResultItem(title: "Generative UI Renderer", subtitle: "text, sourceCard, metricCard, chart, buttons, forms", url: nil, action: nil),
                ResultItem(title: "Tool Router", subtitle: "openURL, searchSefaria, runShortcut, saveNote, runJavaScript", url: nil, action: nil)
            ]))
        ])
    }
}

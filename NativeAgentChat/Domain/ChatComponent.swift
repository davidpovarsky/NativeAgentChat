import Foundation

enum ChatComponent: Codable, Sendable, Hashable {
    case text(TextComponent)
    case metricCard(MetricCardComponent)
    case chart(ChartComponent)
    case resultList(ResultListComponent)
    case sourceCard(SourceCardComponent)
    case actionButton(ActionButtonComponent)
    case scriptBlock(ScriptBlockComponent)
    case inputForm(InputFormComponent)

    enum ComponentType: String, Codable {
        case text
        case metricCard
        case chart
        case resultList
        case sourceCard
        case actionButton
        case scriptBlock
        case inputForm
    }

    private enum CodingKeys: String, CodingKey {
        case type
        case content
        case title
        case value
        case trend
        case subtitle
        case points
        case items
        case reference
        case body
        case actions
        case label
        case systemImage
        case action
        case language
        case code
        case fields
        case submitAction
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(ComponentType.self, forKey: .type)

        switch type {
        case .text:
            self = .text(try TextComponent(from: decoder))
        case .metricCard:
            self = .metricCard(try MetricCardComponent(from: decoder))
        case .chart:
            self = .chart(try ChartComponent(from: decoder))
        case .resultList:
            self = .resultList(try ResultListComponent(from: decoder))
        case .sourceCard:
            self = .sourceCard(try SourceCardComponent(from: decoder))
        case .actionButton:
            self = .actionButton(try ActionButtonComponent(from: decoder))
        case .scriptBlock:
            self = .scriptBlock(try ScriptBlockComponent(from: decoder))
        case .inputForm:
            self = .inputForm(try InputFormComponent(from: decoder))
        }
    }

    func encode(to encoder: Encoder) throws {
        switch self {
        case .text(let component): try component.encode(to: encoder)
        case .metricCard(let component): try component.encode(to: encoder)
        case .chart(let component): try component.encode(to: encoder)
        case .resultList(let component): try component.encode(to: encoder)
        case .sourceCard(let component): try component.encode(to: encoder)
        case .actionButton(let component): try component.encode(to: encoder)
        case .scriptBlock(let component): try component.encode(to: encoder)
        case .inputForm(let component): try component.encode(to: encoder)
        }
    }
}

struct TextComponent: Codable, Sendable, Hashable {
    let type: ChatComponent.ComponentType
    var content: String

    init(content: String) {
        self.type = .text
        self.content = content
    }
}

struct MetricCardComponent: Codable, Sendable, Hashable {
    let type: ChatComponent.ComponentType
    var title: String
    var value: String
    var trend: Double?
    var subtitle: String?

    init(title: String, value: String, trend: Double? = nil, subtitle: String? = nil) {
        self.type = .metricCard
        self.title = title
        self.value = value
        self.trend = trend
        self.subtitle = subtitle
    }
}

struct ChartComponent: Codable, Sendable, Hashable {
    let type: ChatComponent.ComponentType
    var title: String
    var subtitle: String?
    var points: [ChartPoint]

    init(title: String, subtitle: String? = nil, points: [ChartPoint]) {
        self.type = .chart
        self.title = title
        self.subtitle = subtitle
        self.points = points
    }
}

struct ChartPoint: Codable, Identifiable, Sendable, Hashable {
    var id: String { label }
    var label: String
    var value: Double
}

struct ResultListComponent: Codable, Sendable, Hashable {
    let type: ChatComponent.ComponentType
    var title: String
    var items: [ResultItem]

    init(title: String, items: [ResultItem]) {
        self.type = .resultList
        self.title = title
        self.items = items
    }
}

struct ResultItem: Codable, Identifiable, Sendable, Hashable {
    var id: String { title + (url ?? "") }
    var title: String
    var subtitle: String?
    var url: String?
    var action: ToolAction?
}

struct SourceCardComponent: Codable, Sendable, Hashable {
    let type: ChatComponent.ComponentType
    var title: String
    var reference: String
    var body: String
    var actions: [ToolAction]

    init(title: String, reference: String, body: String, actions: [ToolAction] = []) {
        self.type = .sourceCard
        self.title = title
        self.reference = reference
        self.body = body
        self.actions = actions
    }
}

struct ActionButtonComponent: Codable, Sendable, Hashable {
    let type: ChatComponent.ComponentType
    var label: String
    var systemImage: String?
    var action: ToolAction

    init(label: String, systemImage: String? = nil, action: ToolAction) {
        self.type = .actionButton
        self.label = label
        self.systemImage = systemImage
        self.action = action
    }
}

struct ScriptBlockComponent: Codable, Sendable, Hashable {
    let type: ChatComponent.ComponentType
    var language: String
    var code: String
    var action: ToolAction?

    init(language: String, code: String, action: ToolAction? = nil) {
        self.type = .scriptBlock
        self.language = language
        self.code = code
        self.action = action
    }
}

struct InputFormComponent: Codable, Sendable, Hashable {
    let type: ChatComponent.ComponentType
    var title: String
    var fields: [InputField]
    var submitAction: ToolAction

    init(title: String, fields: [InputField], submitAction: ToolAction) {
        self.type = .inputForm
        self.title = title
        self.fields = fields
        self.submitAction = submitAction
    }
}

struct InputField: Codable, Identifiable, Sendable, Hashable {
    var id: String { name }
    var name: String
    var label: String
    var placeholder: String?
    var value: String?
}

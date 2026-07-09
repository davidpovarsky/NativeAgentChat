# Architecture

```text
SwiftUI App
  RootView
    ChatView
      ChatEngine
        AIClient
          DemoAIClient
          OpenAIClient
          AnthropicClient
        AIResponseDecoder
      ComponentRenderer
        Text
        MetricCard
        Chart
        ResultList
        SourceCard
        ActionButton
        ScriptBlock
        InputForm
      ToolRouter
        openURL
        searchSefaria
        runShortcut
        saveNote
        runJavaScript
```

## Model contract

The model should return only JSON:

```json
{
  "components": [
    { "type": "text", "content": "Hello" }
  ],
  "actions": []
}
```

## Why not let the model render UI directly?

The model does not create SwiftUI views. It returns a declarative JSON payload. The app decides how to render it using local native SwiftUI components.

## Why not let the model run arbitrary scripts?

Free-form code is risky and hard to review. The recommended production pattern is allow-listed actions with typed parameters.

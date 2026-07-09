# NativeAgentChat

NativeAgentChat is a native SwiftUI iPad/iOS starter project for a model-agnostic AI chat shell with Generative UI and local tool actions.

It is intentionally dependency-light so it can be opened and compiled quickly in Xcode before adding heavier packages.

## What is included

- Native SwiftUI app shell using `NavigationSplitView`, `List`, `Form`, `GroupBox`, `Grid`, `Button`, `TextField`, and system controls.
- Chat engine with model adapters:
  - Demo / offline adapter
  - OpenAI-compatible chat completions adapter
  - Anthropic Messages adapter
- Generative UI JSON schema:
  - `text`
  - `metricCard`
  - `chart`
  - `resultList`
  - `sourceCard`
  - `actionButton`
  - `scriptBlock`
  - `inputForm`
- Native SwiftUI renderer for every component.
- Tool router:
  - `openURL`
  - `searchSefaria`
  - `runShortcut`
  - `saveNote`
  - `runJavaScript`
- Local JavaScript execution via JavaScriptCore, disabled by default.
- Confirmation prompt before actions, enabled by default.

## How to run

1. Open `NativeAgentChat.xcodeproj` in Xcode.
2. Select an iPad/iPhone simulator or a real device.
3. Run the app.
4. Keep provider as `Demo / Offline` first.
5. Try prompts such as:
   - `תציג גרף`
   - `חפש בספריא ברכות`
   - `תן סקריפט JavaScript`

## Using real models

Open Settings inside the app and choose either:

- `OpenAI-compatible`
- `Claude / Anthropic`

Then add your API key and model name.

The OpenAI-compatible adapter uses:

```text
POST {baseURL}/chat/completions
```

That makes it usable not only for OpenAI, but also for many OpenAI-compatible endpoints.

## Important safety note

The app supports a `runJavaScript` action, but it is disabled by default and should not be used as the main production automation model.

The safer architecture is:

```text
AI returns named actions + parameters
App runs allow-listed local tools
```

For example:

```json
{
  "name": "searchSefaria",
  "parameters": {
    "query": "ברכות ב"
  }
}
```

Prefer that over arbitrary model-generated code.

## Where to extend

- Add real Sefaria/Otzaria integration in `Services/Tools/ToolRouter.swift`.
- Add MCP client support as a separate service module.
- Replace the simple internal renderer with A2UI Swift renderer if desired.
- Add MarkdownUI for richer assistant text rendering.
- Add persistence for chat history.

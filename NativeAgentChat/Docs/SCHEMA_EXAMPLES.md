# Schema examples

## Text

```json
{
  "components": [
    { "type": "text", "content": "Plain native text." }
  ],
  "actions": []
}
```

## Source card with action

```json
{
  "components": [
    {
      "type": "sourceCard",
      "title": "ברכות ב׳ ע״א",
      "reference": "Talmud Bavli",
      "body": "Short source summary.",
      "actions": [
        {
          "name": "searchSefaria",
          "parameters": { "query": "ברכות ב" }
        }
      ]
    }
  ],
  "actions": []
}
```

## Chart

```json
{
  "components": [
    {
      "type": "chart",
      "title": "Usage",
      "points": [
        { "label": "A", "value": 10 },
        { "label": "B", "value": 15 }
      ]
    }
  ],
  "actions": []
}
```

## Action button

```json
{
  "components": [
    {
      "type": "actionButton",
      "label": "Open Sefaria",
      "systemImage": "magnifyingglass",
      "action": {
        "name": "searchSefaria",
        "parameters": { "query": "ברכות" }
      }
    }
  ],
  "actions": []
}
```

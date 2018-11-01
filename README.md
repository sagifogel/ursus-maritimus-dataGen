# ursus-maritimus-dataGen

Data generator tool for the <a href="https://github.com/sagifogel/ursus-maritimus">ursus-maritimus</a> project, 
which generates events with the following JSON schema

```json
{
  "$schema": "http://json-schema.org/draft-04/schema#",
  "type": "object",
  "properties": {
    "event_type": {
      "type": "string"
    },
    "data": {
      "type": "string"
    },
    "timestamp": {
      "type": "integer"
    }
  },
  "required": [
    "event_type",
    "data",
    "timestamp"
  ]
}
```

# Structural Examples

## site

```
{
  "data": {
    "type": "site",
    "id": "",
    "attributes": {
      "domain": ...
      "favicon": ...
      "frontend_url": ...
      "global_seo": ...
      "internal_domain": ...
      "locales": ...
      "name": ...
      "no_index": ...
      "ssg": ...
      "theme_hue: ...
    },
    "relationships": {
      "account": {},
      "item_types": {
        "data": [
          {"id": "...", "type": "item_type"},
          ...
        ]
      },
      "menu_items": {
        "data": [
          {"id": "...", "type": "menu_item"},
          ...
        ]
      },
      "users": {},
    }
  },
  "included": [
    {
      "id": "",
      "type": "item_type",
      "attributes": {
        "name": "",
        "singleton": true|false,
        "sortable": true|false,
        "api_key": "...",
        "ordering_direction": null|???
      },
      "relationships": {
        "fields": {
          "data": [
            {
              "id": "nnn",
              "type": "field"
            },
            ...
          ]
        }
      },
      "singleton_item": {
        "data": null
      },
      "ordering_field": {
        "data": null
      }
    },
    ...
    {
      "id": "",
      "type": "field",
      "attributes": {
        "label": "Foo",
        "field_type": "string|...",
        "api_key": "...",
        "hint": null|...,
        "localized": true|false,
        "validators": {...},
        "position": integer,
        "appeareance": {
          "type": "title|..."
        }
      },
      "relationships": {
        "item_type": {
          "data": {
            "id": "...",
            "type": "item_type"
          }
        }
      }
    },
    ...
  ]
}
```

## items

```
{
  "data": [
    {
      "id": "...",
      "type": "item",
      "attributes": {
        "updated_at": "YYYY-MM-...",
        "is_valid": true|false,
        fields follow, with "api_key" as key...
      },
      "relationships": {
        "item_type" {
          "data": {
            "id": "...",
            "type": "item_type"
          }
        },
        "last_editor": {
          "data": {
            "id": "...",
            "type": "user"
          }
        }
      }
    }
  ],
  "meta": {
    "total_count": integer
  }
}
```

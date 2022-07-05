# Group Notificações

## Notificações [/notifications]
### Métodos HTTP disponíveis [OPTIONS]

+ Request

    + Headers

                Origin:  https://www.mesalva.com
                Access-Control-Request-Method:  GET


+ Response 200 (text/plain)

    + Headers

                Access-Control-Allow-Origin: https://www.mesalva.com
                Access-Control-Allow-Methods: HEAD, OPTIONS, GET, POST, PUT, PATCH, DELETE
                Access-Control-Expose-Headers: access-token, expiry, token-type, uid, client, x-date
                Access-Control-Max-Age: 1728000
                Connection: close
                Transfer-Encoding: chunked

### Lista todas notificações do usuário [GET]

+ Request (application/json)
    + Headers

                uid:  user@integration.com
                access-token:  kaTuL76JKSqWb9PmwnQYQA
                token-type:  Bearer
                client:  WEB

+ Response 200 (application/json; charset=utf-8)
    + Body
                {"data": [
                  {
                    "id": "1",
                    "type": "notification",
                    "attributes": {
                      "notification_type": "essay_draft_created_but_not_sent"
                    },
                    "relationships": {
                      "notification_events": {
                        "data": [
                          {
                            "id": "1",
                            "type": "notification_event"
                          }
                        ]
                      }
                    }
                  }
                ],
                "included": [
                  {
                    "id": "1",
                    "type": "notification_event",
                    "attributes": {
                      "read": true
                    }
                  }
                ]
              }

## Evento de Notificações [/notifications_events]
### Métodos HTTP disponíveis [OPTIONS]

+ Request

    + Headers

                Origin:  https://www.mesalva.com
                Access-Control-Request-Method:  GET


+ Response 200 (text/plain)

    + Headers

                Access-Control-Allow-Origin: https://www.mesalva.com
                Access-Control-Allow-Methods: HEAD, OPTIONS, GET, POST, PUT, PATCH, DELETE
                Access-Control-Expose-Headers: access-token, expiry, token-type, uid, client, x-date
                Access-Control-Max-Age: 1728000
                Connection: close
                Transfer-Encoding: chunked

## Evento de Notificações [/notification_events]
### Criação de evento de notificação [POST]


+ Request (application/json)
    + Body

                {
                  "notification_id": "1",
                  "read": true
                }
    + Headers

                uid:  user@integration.com
                access-token:  kaTuL76JKSqWb9PmwnQYQA
                token-type:  Bearer
                client:  WEB

+ Response 201 (application/json; charset=utf-8)
    + Body
                {
                  "data": {
                    "id": "2",
                    "type": "notification_event",
                    "attributes": {
                      "read": true
                    }
                  }
                }


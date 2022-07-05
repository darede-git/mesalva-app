# Group Cancelamentos

## Questionários de Cancelamento [/cancellation_quizzes]
### Métodos HTTP disponíveis [OPTIONS]

+ Request
    + Headers

                Origin:  https://www.mesalva.com
                Access-Control-Request-Method:  POST


+ Response 200 (text/plain)
    + Headers

                Access-Control-Allow-Origin: https://www.mesalva.com
                Access-Control-Allow-Methods: HEAD, OPTIONS, GET, POST, PUT, PATCH, DELETE
                Access-Control-Expose-Headers: access-token, expiry, token-type, uid, client, x-date
                Access-Control-Max-Age: 1728000
                Connection: close
                Transfer-Encoding: chunked


### Criação de questionários de cancelamento [POST]

+ Request (application/json)
    + Body

                  {
                    "quiz": {
                      "answer1": "Entrei de férias",
                      "answer2": "6",
                      "answer3": "6",
                      "question1": "Por que você optou por cancelar sua assinatura?",
                      "question2": "Como você avalia sua experiência no Me Salva?",
                      "question3": "Você recomendaria o Me Salva! para um amigo ou colega?"
                    },
                    "order_id": "AoXz1Y4kWW8q9WdB",
                    "net_promoter_score_attributes": {
                      "score": "9",
                      "reason": "Amo o Me Salva!"
                    }
                  }

    + Headers

                  uid:  user@cancellation.com
                  access-token:  kaTuL76JKSqWb9PmwnQYQA
                  client:  WEB

+ Response 201 (application/json; charset=utf-8)
    + Body

                  {
                    "data": {
                      "id": "1",
                      "type": "cancellation-quizzes",
                      "attributes": {
                        "user-uid": "user@cancellation.com",
                        "order-id": "AoXz1Y4kWW8q9WdB",
                        "quiz": {
                          "answer1": "Entrei de férias",
                          "answer2": "6",
                          "answer3": "6",
                          "question1": "Por que você optou por cancelar sua assinatura?",
                          "question2": "Como você avalia sua experiência no Me Salva?",
                          "question3": "Você recomendaria o Me Salva! para um amigo ou colega?"
                        }
                      },
                      "relationships": {
                        "net-promoter-score": {
                          "data": null
                        }
                      }
                    }
                  }


## Cancelamentos [/unsubscribes]
### Métodos HTTP disponíveis [OPTIONS]

+ Request
    + Headers

                Origin:  https://www.mesalva.com
                Access-Control-Request-Method:  PUT


+ Response 200 (text/plain)
    + Headers

                Access-Control-Allow-Origin: https://www.mesalva.com
                Access-Control-Allow-Methods: HEAD, OPTIONS, GET, POST, PUT, PATCH, DELETE
                Access-Control-Expose-Headers: access-token, expiry, token-type, uid, client, x-date
                Access-Control-Max-Age: 1728000
                Connection: close
                Transfer-Encoding: chunked


## Cancelamento [/unsubscribes/{subscription_id}]
### Cancelar uma assinatura [PUT]

+ Request (application/json)
    + Parameters
        + subscription_id: `BoYz1Z4kBB8q9WdA` (string, required) - Id da assinatura

    + Headers

                uid:  user@integration.com
                access-token:  kaTuL76JKSqWb9PmwnQYQA
                client:  WEB

+ Response 200 (application/json; charset=utf-8)
    + Body

                {
                  "data": {
                    "id": "BoYz1Z4kBB8q9WdA",
                    "type": "subscriptions",
                    "attributes": {
                      "active": false
                    }
                  }
                }

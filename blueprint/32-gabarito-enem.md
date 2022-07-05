# Gabaritos do Enem

## Gabarito do Enem [/answer_grids?year={year}]
### Métodos HTTP disponíveis [OPTIONS]

+ Request

    + Headers

                Origin:  https://www.mesalva.com
                Access-Control-Request-Method:  GET
                Access-Control-Request-Headers:  X-Requested-With

    + Parameters

        + year: `2018` (string, required) - Ano do gabarito

+ Response 200 (text/plain)

    + Headers

                Access-Control-Allow-Origin: https://www.mesalva.com
                Access-Control-Allow-Methods: HEAD, OPTIONS, GET, POST, PUT, PATCH, DELETE
                Access-Control-Expose-Headers: access-token, expiry, token-type, uid, client, x-date
                Access-Control-Max-Age: 1728000
                Connection: close
                Transfer-Encoding: chunked


### Lista da ultima prova do usuário por exame [GET]

+ Request (application/json)
    + Headers

                uid:  user@integration.com
                access-token:  kaTuL76JKSqWb9PmwnQYQA
                token-type:  Bearer
                client:  WEB

+ Response 200 (application/json; charset=utf-8)
    + Body

                {
                  "data": [{
                    "id": "1",
                    "type": "enem-answer-grids",
                    "attributes": {
                      "exam": "ling",
                      "color": "blue",
                      "language": "esp",
                      "year": "2018"
                    },
                    "relationships": {
                      "answers": {
                        "data": [{
                          "id": "1",
                          "type": "enem-answers"
                        }, {
                          "id": "2",
                          "type": "enem-answers"
                        }]
                      }
                    }
                  }],
                  "included": [{
                    "id": "1",
                    "type": "enem-answers",
                    "attributes": {
                      "question-id": 1,
                      "value": "A",
                      "correct-value": "A",
                      "alternative-id": 1,
                      "correct": true
                    }
                  }, {
                    "id": "2",
                    "type": "enem-answers",
                    "attributes": {
                      "question-id": 2,
                      "value": "A",
                      "correct-value": "A",
                      "alternative-id": 6,
                      "correct": true
                    }
                  }]
                }

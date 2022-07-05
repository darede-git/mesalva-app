# Group Simulados

## Simulados [/prep_test_events]
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


### Resposta de um simulado [POST]

+ Request (application/json)
    + Headers

                uid:  user@integration.com
                access-token:  kaTuL76JKSqWb9PmwnQYQA
                client:  WEB
                location: -2.74, 63.21
                platform: IOS
                device: iPhone 6S
                user_agent: meSalva/2.1(20161109.1.497) (iPhone 5; pt) iPhone OS/8.4
                utm-source: enem
                utm-medium: 320banner
                utm-term: matematica
                utm-content: textlink
                utm-campaign: mkt

    + Body

                {
                  "answers": [{
                    "slug": "enem-e-vestibulares/plano-de-estudos-1/matematica-e-suas-tecnologias/matematica/trigonometria/exercicios-de-trigo/exercicio-1",
                    "answer_id": 1,
                    "event_name": "prep_test_answer",
                    "starts_at": "02/06/2017 15:44:43"
                  }, {
                    "slug": "enem-e-vestibulares/plano-de-estudos-1/matematica-e-suas-tecnologias/matematica/algebra-linear/exercicios-de-algebra/exercicio-10",
                    "answer_id": 1,
                    "event_name": "prep_test_answer",
                    "starts_at": "02/06/2017 15:44:43"
                  }]
                }

+ Response 201 (application/json; charset=utf-8)
    + Body

                {
                  "data": {
                    "id": "9",
                    "type": "permalinks",
                    "attributes": {
                      "slug": "enem-e-vestibulares/plano-de-estudos-1/matematica-e-suas-tecnologias/matematica/algebra-linear/exercicios-de-algebra/exercicio-10"
                    }
                  },
                  "meta": {
                    "answers": [{
                      "slug": "exercicio",
                      "correct": true,
                      "correction": "Sample correction",
                      "submission-token": "MjAxNy0wOC0wNyAyMToxMDo1MS4yODQyMTg5ODAgKzAwMDA",
                      "medium-text": "Sample text",
                      "answer-correct": 1
                    }, {
                      "slug": "exercicio2",
                      "correct": false,
                      "correction": "Sample correction",
                      "submission-token": "MjAxNy0wOC0wNyAyMToxMDo1MS4yODQyMTg5ODAgKzAwMDA",
                      "medium-text": "Sample text",
                      "answer-correct": 6
                    }]
                  }
                }


### Lista de simulados feitos pelo usuário filtrado por node_module [GET]

+ Request (application/json)
    + Headers

                uid:  user@integration.com
                access-token:  kaTuL76JKSqWb9PmwnQYQA
                client:  WEB
                location: -2.74, 63.21
                platform: IOS
                device: iPhone 6S
                user_agent: meSalva/2.1(20161109.1.497) (iPhone 5; pt) iPhone OS/8.4

    + Body

                {
                  "node_module_slug":  "algebra-linear"
                }

+ Response 200 (application/json; charset=utf-8)
    + Body

                {
                  "results": {
                    "prep-tests": [{
                      "item-slug": "basico",
                      "item-name": "Basico",
                      "submission-token": "token",
                      "submission-at": "2017-01-01 12:00:00"
                    }]
                  }
                }

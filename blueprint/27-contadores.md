# Group Contadores

## Permalinks [/permalink_counters]
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


## Contadores de Permalink [/permalink_counters/{id}]
### Permalink counter terminado em medium [GET]

+ Parameters
    + id: `enem-e-vestibulares/plano-de-estudos-1/matematica-e-suas-tecnologias/matematica` (string, required) - permalinks/{id}

+ Request (application/json; charset=utf-8)

+ Response 200 (application/json; charset=utf-8)
    + Body
                {
                  "permalink-counter": {
                    "slug": "enem-e-vestibulares/plano-de-estudos-1/matematica-e-suas-tecnologias/matematica",
                    "seconds-duration": 0,
                    "node-module-count": 2,
                    "medium-count": {
                      "text": 1,
                      "comprehension-exercise": 0,
                      "fixation-exercise": 1,
                      "video": 1,
                      "pdf": 0,
                      "essay": 0
                    },
                    "node-modules": [{
                      "slug": "plano-de-estudos-1",
                      "seconds-duration": 0,
                      "node-module-count": 0,
                      "medium-count": {
                        "text": 0,
                        "comprehension-exercise": 0,
                        "fixation-exercise": 0,
                        "video": 0,
                        "pdf": 0,
                        "essay": 0
                      }
                    }, {
                      "slug": "propostas-de-correcao-de-redacao",
                      "seconds-duration": 0,
                      "node-module-count": 0,
                      "medium-count": {
                        "text": 0,
                        "comprehension-exercise": 0,
                        "fixation-exercise": 0,
                        "video": 0,
                        "pdf": 0,
                        "essay": 0
                      }
                    }]
                  }
                }

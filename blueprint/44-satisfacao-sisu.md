# Group Satisfação Sisu

## Questionário de Satisfação do simulador Sisu [/sisu_satisfactions]
### Métodos HTTP disponíveis [OPTIONS]

+ Request

    + Headers

                Origin:  http://www.mesalva.com
                Access-Control-Request-Method:  POST

+ Response 200 (text/plain)

    + Headers

                Access-Control-Allow-Origin: http://mesalva.com
                Access-Control-Allow-Methods: HEAD, OPTIONS, POST
                Access-Control-Expose-Headers: access-token, expiry, token-type, uid, client, x-date
                Access-Control-Max-Age: 1728000
                Connection: close
                Transfer-Encoding: chunked


### Cria respostas de satisfação do simulador Sisu [POST]

+ Request (application/json)
    + Headers

                uid:  user@integration.com
                access-token:  kaTuL76JKSqWb9PmwnQYQA
                token-type:  Bearer
                client:  WEB

    + Body

                {
                  "satisfaction": true,
                  "plan": "Entrar em uma universidade federal"
                }

+ Response 201 (application/json; charset=utf-8)
    + Body

                {
                  "data": {
                    "id": "1",
                    "type": "sisu-satisfactions",
                    "attributes": {
                      "satisfaction": true,
                      "plan": "Entrar em uma universidade federal"
                    },
                    "relationships": {
                      "user": {
                        "data": {
                          "id": "user@integration.com",
                          "type": "users"
                        }
                      }
                    }
                  }
                }

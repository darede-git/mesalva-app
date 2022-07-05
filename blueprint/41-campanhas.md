# Group Campanhas

## Campanha Carnaval 2018 [/discounts_campaign/carnaval]
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

### Cria descontos para a campanha [POST]

+ Request (application/json)
    + Headers

                uid:  user@integration.com
                access-token:  kaTuL76JKSqWb9PmwnQYQA
                token-type:  Bearer
                client:  WEB

+ Response 201 (application/json; charset=utf-8)
    + Body

                {
                  "data": {
                    "id": "W_cCJZEXLqG9fgLy",
                    "type": "discounts",
                    "attributes": {
                      "name": "Carnaval 2018",
                      "percentual": 20,
                      "description": "Campanha do carnaval de 2018 de descontos aleatórios",
                      "code": "SURPRESA6E159900"
                    }
                  }
                }

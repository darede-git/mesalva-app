# Group Cartão de crédito Pagarme

## Cartão de crédito Pagarme [/credit_cards]
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


### Cria card_hash do Pagarme [POST]

+ Request (application/json)
    + Headers

                uid:  user@integration.com
                access-token:  kaTuL76JKSqWb9PmwnQYQA
                token-type:  Bearer
                client:  WEB

    + Body

                {
                  "card_number": "4111111111111111",
                  "card_holder_name": "Andre Antunes Vieira",
                  "card_expiration_date": "0925",
                  "card_cvv": "080"
                }

+ Response 201 (application/json; charset=utf-8)
    + Body

                {
                  "data": {
                    "id": "card_cjux4e1sx05p53f6d2kad533d",
                    "type": "credit-card",
                    "attributes": {
                      "valid": true
                    }
                  }
                }

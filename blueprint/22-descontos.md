# Group Desconto

## Descontos [/discounts]
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


### Criar desconto [POST]
##### Criar desconto para um usuário específico passar o campo 'user_id'. Se quiser criar um desconto que seja upsell passar o parâmetro 'upsell_packages' seguindo o mesmo padrão do 'packages'

+ Request (application/json)
    + Body

                {
                  "packages":  ["1", "2"],
                  "name": "Desconto 5% campaing",
                  "starts_at": "2016-05-10 10:00:00",
                  "expires_at": "2016-06-10 10:00:00",
                  "percentual": 5,
                  "code": "DESCONTO5",
                  "description": "Desconto de 5% no pacote 1 e 2"
                }

    + Headers

                uid:  admin@integration.com
                access-token:  LkoOFd6bnxRqk1xJlsQYHA
                client:  WEB

+ Response 201 (application/json; charset=utf-8)
    + Body

                {
                  "data": {
                    "id": "jSpXAUqO6ZboTNw1",
                    "type": "discounts",
                    "attributes": {
                      "name": "Desconto 5% campaing",
                      "percentual": 5,
                      "description": "Desconto de 5% no pacote 1 e 2",
                      "code": "DESCONTO5"
                    }
                  }
                }


## Desconto [/discounts/{id}]
### Busca desconto [GET]

+ Parameters
    + id: `PT2fsrCbdU4u1VpM` (string, required) - Id do desconto

+ Request (application/json)
    + Headers

                uid:  admin@integration.com
                access-token:  LkoOFd6bnxRqk1xJlsQYHA
                client:  WEB

+ Response 200 (application/json; charset=utf-8)
    + Body

                {
                  "data": {
                    "id": "PT2fsrCbdU4u1VpM",
                    "type": "discounts",
                    "attributes": {
                      "name": "Desconto 20%",
                      "percentual": 20,
                      "description": "Desconto de 20% no pacote 1 e 2",
                      "code": "Desconto20"
                    }
                  }
                }


### Atualização de desconto [PUT]
##### Campos que podem ser alterados: starts_at, expires_at, description, user_id, packages, upsell_packages

+ Parameters
    + id: `PT2fsrCbdU4u1VpM` (string, required) - Id do desconto

+ Request (application/json)
    + Body

                {
                  "description": "Description update"
                }

    + Headers

                uid:  admin@integration.com
                access-token:  LkoOFd6bnxRqk1xJlsQYHA
                client:  WEB

+ Response 200 (application/json; charset=utf-8)
    + Body

                {
                  "data": {
                    "id": "PT2fsrCbdU4u1VpM",
                    "type": "discounts",
                    "attributes": {
                      "name": "Desconto 20%",
                      "percentual": 20,
                      "description": "Description update",
                      "code": "Desconto20"
                    }
                  }
                }


## Desconto [/redeem]
### Uso de um desconto [POST]
+ Request (application/json)
    + Body

              {
                "code": "Desconto20",
                "package_slug": "enem-semestral1"
              }

    + Headers

                uid:  user@integration.com
                access-token:  kaTuL76JKSqWb9PmwnQYQA
                client:  WEB

+ Response 200 (application/json; charset=utf-8)
    + Body

                {
                  "data": {
                    "id": "PT2fsrCbdU4u1VpM",
                    "type": "discounts",
                    "attributes": {
                      "name": "Desconto 20%",
                      "percentual": 20,
                      "description": "Description update",
                      "code": "Desconto20"
                    }
                  }
                }

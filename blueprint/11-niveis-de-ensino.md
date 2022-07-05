# Group Níveis de ensino

## Lista de Nível de Ensino [/education_levels]
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


### Listagem de todos os níveis de ensino [GET]

+ Request (application/json; charset=utf-8)
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
                    "type": "education-levels",
                    "attributes": {
                      "name": "Ensino médio completo"
                    }
                  }]
                }


## Nível de Ensino [/education_levels/{id}]
### Atualização de níveis de ensino [PUT]

+ Parameters
    + id: `1` (number, required) - Id do nível de Ensino

+ Request (application/json)
    + Body

                {
                  "id": "1",
                  "name": "Ensino superior em andamento"
                }

    + Headers

                uid:  admin@integration.com
                access-token:  LkoOFd6bnxRqk1xJlsQYHA
                client:  WEB

+ Response 200 (application/json; charset=utf-8)
    + Body

                {
                  "data": {
                    "id": "1",
                    "type": "education",
                    "attributes": {
                      "name": "Ensino superior em andamento"
                    }
                  }
                }

# Group Objetivos

## Lista de Objetivos [/objectives]
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


### Lista de todos os objetivos [GET]

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
                    "type": "objectives",
                    "attributes": {
                      "name": "Estudar para o ensino fundamental",
                      "education-segment-slug": null
                    }
                  }, {
                    "id": "2",
                    "type": "objectives",
                    "attributes": {
                      "name": "Estudar para o ensino médio",
                      "education-segment-slug": "ensino-medio"
                    }
                  }, {
                    "id": "3",
                    "type": "objectives",
                    "attributes": {
                      "name": "Estudar para o curso técnico",
                      "education-segment-slug": null
                    }
                  }, {
                    "id": "4",
                    "type": "objectives",
                    "attributes": {
                      "name": "Estudar para o ENEM e Vestibulares",
                      "education-segment-slug": "enem-e-vestibulares"
                    }
                  }, {
                    "id": "5",
                    "type": "objectives",
                    "attributes": {
                      "name": "Estudar para o ENEM",
                      "education-segment-slug": "enem-e-vestibulares"
                    }
                  }, {
                    "id": "6",
                    "type": "objectives",
                    "attributes": {
                      "name": "Estudar para vestibulares",
                      "education-segment-slug": "enem-e-vestibulares"
                    }
                  }, {
                    "id": "7",
                    "type": "objectives",
                    "attributes": {
                      "name": "Estudar Engenharia",
                      "education-segment-slug": "engenharia"
                    }
                  }, {
                    "id": "8",
                    "type": "objectives",
                    "attributes": {
                      "name": "Estudar Ciências da saúde",
                      "education-segment-slug": "saude"
                    }
                  }, {
                    "id": "9",
                    "type": "objectives",
                    "attributes": {
                      "name": "Estudar Negócios (Administração, ciências econômicas e afins)",
                      "education-segment-slug": "negocios"
                    }
                  }, {
                    "id": "10",
                    "type": "objectives",
                    "attributes": {
                      "name": "Estudar para concurso",
                      "education-segment-slug": null
                    }
                  }, {
                    "id": "11",
                    "type": "objectives",
                    "attributes": {
                      "name": "Estudar para pós-graduação",
                      "education-segment-slug": null
                    }
                  }, {
                    "id": "12",
                    "type": "objectives",
                    "attributes": {
                      "name": "Estudar para um conteúdo específico",
                      "education-segment-slug": null
                    }
                  }]
                }


## Objetivo [/objectives/{id}]
### Atualização de objetivos [PUT]

+ Parameters
    + id: `1` (number, required) - Id do objetivo

+ Request (application/json)
    + Body

                {
                  "id": "13",
                  "name": "Publicar a API do MeSalva!"
                }

    + Headers

                uid:  admin@integration.com
                access-token:  LkoOFd6bnxRqk1xJlsQYHA
                client:  WEB

+ Response 200 (application/json; charset=utf-8)
    + Body

                {
                  "data": {
                    "id": "13",
                    "type": "objectives",
                    "attributes": {
                      "name": "Publicar a API do MeSalva!",
                      "education-segment-slug": "backend"
                    }
                  }
                }

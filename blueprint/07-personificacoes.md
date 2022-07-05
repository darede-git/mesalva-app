# Group Personificações

## Personificações de estudantes [/admin/impersonations]
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


### Force login de estudantes e professores [POST]

+ Request (application/json)
    + Body

                {
                  "uid": "user@impersonations.com"
                }

    + Headers

                uid:  admin@integration.com
                access-token:  LkoOFd6bnxRqk1xJlsQYHA
                client:  WEB

+ Response 200 (application/json; charset=utf-8)
    + Body

                {
                  "data":
                    { "id": "1",
                      "type": "users",
                      "attributes":
                        {
                          "provider": "email",
                          "uid": "user@impersonations.com",
                          "name": null,
                          "image":
                            {
                              "url":null
                            },
                          "email": "user@impersonations.com",
                          "birth-date": null,
                          "gender": null,
                          "studies": null,
                          "dreams": null,
                          "premium": false,
                          "origin": null,
                          "active": true,
                          "created-at": "2017-02-12T08:44:42.174Z"
                        },
                      "relationships":
                        {
                          "address":
                            { "data": null },
                          "academic-info":
                            { "data": null },
                          "education-level": {
                            "data": {
                              "id": "1",
                              "type": "education-levels"
                            }
                          },
                          "objective": {
                            "data": {
                              "id": "1",
                              "type": "objectives"
                            }
                          }
                        }
                      },
                      "included": [{
                        "id": "2",
                        "type": "education-levels",
                        "attributes": {
                          "name": "Ensino fundamental concluído"
                        }
                      }, {
                        "id": "2",
                        "type": "objectives",
                        "attributes": {
                          "name": "Estudar para o ensino médio",
                          "education-segment-slug": "ensino-medio"
                        }
                      }]
                    }

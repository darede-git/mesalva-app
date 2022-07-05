# Group Registros

## Registro de Estudante [/user]
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


### Registro de estudantes [POST]

+ Request (application/json)
    + Headers

                client: WEB

    + Body

                {
                  "name": "Rafael Nadal",
                  "email": "user@registro.com",
                  "password": "12345678",
                  "password_confirmation": "12345678"
                }

+ Response 201 (application/json; charset=utf-8)
    + Body

                {
                  "data":
                    { "id": "user@registro.com",
                      "type": "users",
                      "attributes":
                        {
                          "provider": "email",
                          "uid": "user@registro.com",
                          "name": "Rafael Nadal",
                          "image":
                            {
                              "url": null
                            },
                          "email": "user@registro.com",
                          "birth-date": null,
                          "gender": null,
                          "studies": null,
                          "dreams": null,
                          "premium": false,
                          "origin": null,
                          "active": true,
                          "created-at" : "2017-02-12T08:44:42.174Z"
                        },
                      "relationships":
                        {
                          "address":
                            { "data": null },
                          "academic-info":
                            { "data": null },
                          "education-level":
                            { "data": null },
                          "objective":
                            { "data": null }
                        }
                    }
                }

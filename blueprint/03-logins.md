# Group Logins

### Login de Usuário com facebook [POST]
###### Para login com *google*, usar a rota (/user/**google**/callback) com os mesmos parametros.

+ Request (application/json)
    + Headers

                client:  WEB

    + Body

                {
                  "token": "EAAB2R9ApZC6QBAKPLl91NOLiJS4JuIkeQZCA4aPvQ07ZBxwXYkosJnLDcgEWnpyV3ZBYhrFQMU8cULZCzhRVgGSsUWTL4qjAU0mb8V7ABZAkWt8oK6ImcP8jSfmdpNVQZBXIG0QAZBtc0CZCaQkU6GfulQc8yJ1si5pnmKhGjhSYgdHex5jLbOk3d"
                }

+ Response 201 (application/json; charset=utf-8)
    + Body

                {
                  "data": {
                    "id": "104758079989784",
                    "type": "users",
                    "attributes": {
                      "provider": "facebook",
                      "uid": "104758079989784",
                      "name": "MayconSeidel",
                      "image": {
                        "url": null
                      },
                      "email": null,
                      "birth-date": null,
                      "gender": "female",
                      "studies": null,
                      "dreams": null,
                      "premium": false,
                      "origin": null,
                      "active": true
                    },
                    "relationships": {
                      "address": {
                        "data": null
                      },
                      "academic-info": {
                        "data": null
                      },
                      "education-level": {
                        "data": null
                      },
                      "objective": {
                        "data": null
                      }
                    }
                  }
                }



## Login de Estudantes para outra plataforma [/user/sign_in/{platform}]
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

### Login para outra plataforma [POST]
###### Uma request para este endpoint não invalida os headers da plataforma que fez a requisição.

+ Request (application/json)
    + Parameters
        + platform: `IOS` (string, required)
    + Headers

                uid:  user@integration.com
                access-token:  kaTuL76JKSqWb9PmwnQYQA
                client:  WEB

+ Response 200 (application/json; charset=utf-8)
    + Body

                {
                  "access-token": "NoMyR9PrYFlDEZDhSP3kug",
                  "token-type": "Bearer",
                  "client": "IOS",
                  "expiry": "1513874578",
                  "uid": "user@integration.com"
                }


## Login de Professor [/teacher/sign_in]
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


### Login de professores [POST]

+ Request (application/json)
    + Headers

                client: WEB

    + Body

                {
                  "email": "teacher@login.com",
                  "password": "teacher"
                }

+ Response 202 (application/json; charset=utf-8)
    + Body

                {
                  "data":
                    { "id": "teacher@login.com",
                      "type": "techers",
                      "attributes":
                        { "uid": "teacher@login.com",
                          "name": null,
                          "image":
                            {
                              "url": null
                            },
                          "email": "teacher@login.com",
                          "description": null,
                          "birth-date": null,
                          "active": true
                        }
                    }
                }


## Login de Admin [/admin/sign_in]
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


### Login de administradores [POST]

+ Request (application/json)
    + Headers

                client: WEB

    + Body

                {
                  "email": "admin@login.com",
                  "password": "admin"
                }

+ Response 202 (application/json; charset=utf-8)
    + Body

                {
                  "data":
                    { "id": "admin@login.com",
                      "type": "admins",
                      "attributes":
                        {
                          "uid": "admin@login.com",
                          "name": null,
                          "image":
                            {
                              "url": null
                            },
                          "email": "admin@login.com",
                          "birth-date": null,
                          "active": true
                        }
                    }
                }

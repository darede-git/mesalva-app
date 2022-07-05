# Group Redefinições de senha

## Estudantes [/user/password]
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


### Solicitação de redefinição senha de estudantes [POST]

+ Request (application/json)
    + Body

                {
                  "email": "user@password.com"
                }

+ Response 200 (application/json; charset=utf-8)
    + Body

                {
                  "success": true,
                  "message": "An email has been sent to 'user@password.com' containing instructions for resetting your password."
                }


### Redefinição de senha de estudante [PUT]

+ Request (application/json)
    + Headers

                client: WEB

    + Body

                {
                  "reset_password_token": "zyvuiRYwNNuPJp9iiV1w",
                  "password": "87654321",
                  "password_confirmation": "87654321"
                }

+ Response 200 (application/json; charset=utf-8)
    + Body

                {
                  "data":
                    { "id": "user@reset.com",
                      "type": "users",
                      "attributes":
                        { "provider": "email",
                          "uid": "user@reset.com",
                          "name": null,
                          "image": {"url":null},
                          "email": "user@reset.com",
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
                        { "address":
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


## Professores [/teacher/password]
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


### Solicitação de redefinição senha de professores [POST]

+ Request (application/json)
    + Body

                {
                  "email": "teacher@password.com"
                }

+ Response 200 (application/json; charset=utf-8)
    + Body

                {
                  "success": true,
                  "message": "An email has been sent to 'teacher@password.com' containing instructions for resetting your password."
                }


### Redefinição de senha de professor [PUT]

+ Request (application/json)
    + Headers

                client: WEB

    + Body

                {
                  "reset_password_token": "zyvuiRYwNNuPJp9iiV1w",
                  "password": "87654321",
                  "password_confirmation": "87654321"
                }

+ Response 200 (application/json; charset=utf-8)
    + Body

                {
                  "data":
                    { "id": "teacher@reset.com",
                      "type": "teachers",
                      "attributes":
                        { "uid": "teacher@reset.com",
                          "name":null,
                          "image": { "url": null },
                          "email": "teacher@reset.com",
                          "description": null,
                          "birth-date": null,
                          "active": true
                        }
                    }
                }


## Administradores [/admin/password]
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


### Solicitação de redefinição senha de administradores [POST]

+ Request (application/json)
    + Body

                {
                  "email": "admin@password.com"
                }

+ Response 200 (application/json; charset=utf-8)
    + Body

                {
                  "success": true,
                  "message": "An email has been sent to 'admin@password.com' containing instructions for resetting your password."
                }


### Redefinição de senha de admin [PUT]

+ Request (application/json)
    + Headers

                client: WEB

    + Body

                {
                  "reset_password_token": "zyvuiRYwNNuPJp9iiV1w",
                  "password": "87654321",
                  "password_confirmation": "87654321"
                }

+ Response 200 (application/json; charset=utf-8)
    + Body

                {
                  "data":
                    { "id": "admin@reset.com",
                      "type": "admins",
                      "attributes":
                        { "uid": "admin@reset.com",
                          "name":null,
                          "image": { "url": null },
                          "email": "admin@reset.com",
                          "description": null,
                          "birth-date": null,
                          "active": true
                        }
                    }
                }

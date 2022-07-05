# Group Convites

## Professores [/teacher/invitation]
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


### Convite de professores [POST]

+ Request (application/json)
    + Body

                {
                  "email": "teacher@invite.com",
                  "name": "Teacher Guest"
                }

    + Headers

                uid:  admin@integration.com
                access-token:  LkoOFd6bnxRqk1xJlsQYHA
                client:  WEB

+ Response 201 (application/json; charset=utf-8)
    + Body

                {
                  "data":
                    { "id": "teacher@invite.com",
                      "type": "teachers",
                      "attributes":
                        { "uid": "teacher@invite.com",
                          "name": "Teacher Guest",
                          "image": { "url": null },
                          "email": "teacher@invite.com",
                          "description": null,
                          "birth-date": null,
                          "active": true
                        }
                    }
                }


### Aceitar convite de professor [PUT]

+ Request (application/json)
    + Headers

                client: WEB

    + Body

                {
                  "invitation_token": "yzktDzhWE3uQnLnQyzQi",
                  "password": "12345678",
                  "password_confirmation": "12345678"
                }

+ Response 202 (application/json; charset=utf-8)
    + Body

                {
                  "success": ["Teacher updated."]
                }



## Administradores [/admin/invitation]
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


### Convite de administradores [POST]

+ Request (application/json)
    + Body

                {
                  "email": "admin@invite.com",
                  "name": "Admin Guest"
                }

    + Headers

                uid:  admin@integration.com
                access-token:  LkoOFd6bnxRqk1xJlsQYHA
                client:  WEB

+ Response 201 (application/json; charset=utf-8)
    + Body

                {
                  "data":
                    { "id": "admin@invite.com",
                      "type": "admins",
                      "attributes":
                        { "uid": "admin@invite.com",
                          "name": "Admin Guest",
                          "image": { "url": null },
                          "email": "admin@invite.com",
                          "description": null,
                          "birth-date": null,
                          "active": true
                        }
                    }
                }


### Aceitar convite de administradores [PUT]

+ Request (application/json)
    + Headers

                client: WEB

    + Body

                {
                  "invitation_token": "XzcT-3JLdpuuwBJy3sVy",
                  "password": "12345678",
                  "password_confirmation": "12345678"
                }

+ Response 202 (application/json; charset=utf-8)
    + Body

                {
                  "success": ["Admin updated."]
                }

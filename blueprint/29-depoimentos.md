# Group Testimonials

## Depoimentos [/testimonials]
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


### Criação de depoimentos [POST]

+ Request (application/json)
    + Headers

                uid:  admin@integration.com
                access-token:  LkoOFd6bnxRqk1xJlsQYHA
                client:  WEB
    + Body

                {
                  "text": "O Me Salva! me ajudou com o ENEM!",
                  "image": "data:image/jpeg;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP4z8DwHwAFAAH/VscvDQAAAABJRU5ErkJggg==",
                  "education_segment_slug": "enem-anual"
                }


+ Response 201 (application/json; charset=utf-8)
    + Body

                {
                  "data": {
                    "id": "mhXGtAtGPMPJTEnk",
                    "type": "testimonials",
                    "attributes": {
                      "text": "O Me Salva! me ajudou com o ENEM!",
                      "user-name": null,
                      "avatar": {
                        "url": null
                      },
                      "created-at": "2017-05-22T20:33:10.510Z",
                      "created-by": null,
                      "updated-by": null,
                      "education-segment-slug": "enem-anual"
                    }
                  }
                }

### Lista de todos os depoimentos [GET]

+ Request (application/json)

+ Response 200 (application/json; charset=utf-8)
    + Body

                {
                  "data": [{
                    "id": "sLSlUkRwBMc37o3S",
                    "type": "testimonials",
                    "attributes": {
                      "text": "Passei em cálculo graças ao Me Salva!",
                      "user-name": "João da Silva",
                      "avatar": {
                        "url": "https://cdnqa.mesalva.com/uploads/image/integration.jpeg"
                      },
                      "created-at": "2017-05-22T20:30:29.552Z",
                      "created-by": "admin@mesalva.com",
                      "updated-by": null,
                      "education-segment-slug": "enem-semestral"
                    }
                  }, {
                    "id": "mhXGtAtGPMPJTEnk",
                    "type": "testimonials",
                    "attributes": {
                      "text": "O Me Salva! me ajudou com o ENEM!",
                      "user-name": null,
                      "avatar": {
                        "url": null
                      },
                      "created-at": "2017-05-22T20:33:10.510Z",
                      "created-by": null,
                      "updated-by": null,
                      "education-segment-slug": "enem-anual"
                    }
                  }]
                }


## Depoimentos [/testimonials/{education_segment_slug}]

### Depoimento filtrado por education_segment_slug [GET]

+ Parameters
    + education_segment_slug: `enem-semestral` (string, required)

+ Request (application/json)

+ Response 200 (application/json; charset=utf-8)
    + Body

                {
                  "data": {
                    "id": "sLSlUkRwBMc37o3S",
                    "type": "testimonials",
                    "attributes": {
                      "text": "Passei em cálculo graças ao Me Salva!",
                      "user-name": "João da Silva",
                      "avatar": {
                        "url": "https://cdnqa.mesalva.com/uploads/image/integration.jpeg"
                      },
                      "created-at": "2017-05-22T20:20:26.527Z",
                      "created-by": "admin@mesalva.com",
                      "updated-by": "admin@integration.com",
                      "education-segment-slug": "enem-semestral"
                    }
                  }
                }


## Depoimentos [/testimonials/{id}]

### Atualização depoimentos [PUT]

+ Request (application/json)
    + Headers

                uid:  admin@integration.com
                access-token:  LkoOFd6bnxRqk1xJlsQYHA
                client:  WEB

    + Parameters
        + id: `sLSlUkRwBMc37o3S` (string, required)

    + Body

                {
                  "testimonial": "O meu Ensino Médio foi mais fácil com o Me Salva!"
                }

+ Response 200 (application/json; charset=utf-8)

                {
                  "data": {
                    "id": "sLSlUkRwBMc37o3S",
                    "type": "testimonials",
                    "attributes": {
                      "text": "Passei em cálculo graças ao Me Salva!",
                      "user-name": "João da Silva",
                      "avatar": {
                        "url": "https://cdnqa.mesalva.com/uploads/image/integration.jpeg"
                      },
                      "created-at": "2017-05-22T20:20:26.527Z",
                      "created-by": "admin@mesalva.com",
                      "updated-by": null,
                      "education-segment-slug": "enem-semestral"
                    }
                  }
                }


### Apaga depoimentos [DELETE]

+ Request (application/json)
    + Headers

                uid:  admin@integration.com
                access-token:  LkoOFd6bnxRqk1xJlsQYHA
                client:  WEB

    + Parameters
        + id: `sLSlUkRwBMc37o3S` (string, required)

+ Response 204

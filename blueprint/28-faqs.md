# Group Faqs

## Perguntas frequentes [/faqs]
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


### Criação de faq [POST]

+ Request (application/json)
    + Headers

                uid:  admin@integration.com
                access-token:  LkoOFd6bnxRqk1xJlsQYHA
                client:  WEB

    + Body

                {
                  "name": "ENEM e Vestibulares",
                  "slug": "enem-e-vestibulares"
                }

+ Response 201 (application/json; charset=utf-8)
    + Body

                  {
                    "data": {
                      "id": "mODyUWXVWiZHq9dL",
                      "type": "faqs",
                      "attributes": {
                        "name": "ENEM e Vestibulares",
                        "created-by": "admin@integration.com",
                        "updated-by": null
                      },
                      "relationships": {
                        "questions": {
                          "data": []
                        }
                      }
                    }
                  }


## Tópico [/faqs/{id}]
### Atualiza um tópico de perguntas [PUT]

+ Request (application/json)
    + Parameters
        + id: `OFd6bnxRqk1xJlsQYha` (string, required)

    + Headers

                uid:  admin@integration.com
                access-token:  LkoOFd6bnxRqk1xJlsQYHA
                client:  WEB

    + Body

                {
                  "name": "ENEM"
                }

+ Response 200 (application/json; charset=utf-8)

                {
                  "data": {
                    "id": "OFd6bnxRqk1xJlsQYha",
                    "type": "faqs",
                    "attributes": {
                      "name": "ENEM",
                      "created-by": null,
                      "updated-by": "admin@integration.com"
                    },
                    "relationships": {
                      "questions": {
                        "data": [{
                          "id": "3jE_nuuyq367vK5a",
                          "type": "questions"
                        }, {
                          "id": "jAgyqxqryG4aKu2S",
                          "type": "questions"
                        }]
                      }
                    }
                  },
                  "included": [{
                    "id": "3jE_nuuyq367vK5a",
                    "type": "questions",
                    "attributes": {
                      "title": "A quais módulos tenho acesso?",
                      "image": {
                        "url": "https://cdnqa.mesalva.com/uploads/image/integration.jpeg"
                      },
                      "answer": "Matemática, Linguagens, Natureza e Humanas",
                      "created-by": "admin@mesalva.com",
                      "updated-by": null
                    }
                  }, {
                    "id": "jAgyqxqryG4aKu2S",
                    "type": "questions",
                    "attributes": {
                      "title": "Quando surgiu o Me Salva!?",
                      "image": {
                        "url": "https://cdnqa.mesalva.com/uploads/image/integration.jpeg"
                      },
                      "answer": "Em 2013",
                      "created-by": "admin@integration.com",
                      "updated-by": null
                    }
                  }]
                }


### Remoção de um tópico de perguntas [DELETE]

+ Request (application/json)
    + Parameters
        + id: `OFd6bnxRqk1xJlsQYha` (string, required)

    + Headers

                uid:  admin@integration.com
                access-token:  LkoOFd6bnxRqk1xJlsQYHA
                client:  WEB

+ Response 204


## Topicos por slug [/faqs{?slug}]
### Lista de topicos [GET]

+ Request (application/json)
    + Parameters
        + slug: `me-salva` (string, optional)

+ Response 200 (application/json; charset=utf-8)
    + Body

                {
                  "data": [{
                    "id": "4B_ct9TGQ4kw24Xq",
                    "type": "faqs",
                    "attributes": {
                      "name": "Geral",
                      "created-by": null,
                      "updated-by": null
                    },
                    "relationships": {
                      "questions": {
                        "data": [{
                          "id": "OFd6bnxRqk1xJlsQYHA",
                          "type": "questions"
                        }]
                      }
                    }
                  }],
                  "included": [{
                    "id": "OFd6bnxRqk1xJlsQYHA",
                    "type": "questions",
                    "attributes": {
                      "title": "O que é o Me Salva!?",
                      "image": {
                        "url": "https://cdnqa.mesalva.com/uploads/image/integration.jpeg"
                      },
                      "answer": "É uma plataforma de estudos online",
                      "created-by": "admin@mesalva.com",
                      "updated-by": "admin2@mesalva.com"
                    }
                  }]
                }


## Perguntas [/faqs/{faq_id}/questions]
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


### Criação de uma pergunta [POST]

+ Request (application/json)
    + Parameters
        + faq_id: `OFd6bnxRqk1xJlsQYha` (string, required)
    + Headers

                uid:  admin@integration.com
                access-token:  LkoOFd6bnxRqk1xJlsQYHA
                client:  WEB

    + Body

                {
                  "title": "Quando surgiu o Me Salva!?",
                  "answer": "Em 2013",
                  "image": "data:image/jpeg;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP4z8DwHwAFAAH/VscvDQAAAABJRU5ErkJggg=="
                }


+ Response 201 (application/json; charset=utf-8)
    + Body

                  {
                    "data": {
                      "id": "L8vLQnk97rEkCkDv",
                      "type": "questions",
                      "attributes": {
                        "title": "Quando surgiu o Me Salva!?",
                        "image": {
                          "url": "https://cdnqa.mesalva.com/uploads/image/integration.jpeg"
                        },
                        "answer": "Em 2013",
                        "created-by": "admin@integration.com",
                        "updated-by": null
                      }
                    }
                  }


## Pergunta [/faqs/{faq_id}/questions/{id}]
### Atualização de uma pergunta [PUT]

+ Request (application/json)
    + Parameters
        + faq_id: `abcdefgh` (string, required)
        + id: `OFd6bnxRqk1xJlsQYHA` (string, required)

    + Headers

                uid:  admin@integration.com
                access-token:  LkoOFd6bnxRqk1xJlsQYHA
                client:  WEB

    + Body

                {
                  "title": "O Me Salva! tem aulas de que áreas?",
                  "answer": "Ensino Médio e ENEM, Engenharias e Ciências da saúde"
                }

+ Response 200 (application/json; charset=utf-8)

                {
                  "data": {
                    "id": "OFd6bnxRqk1xJlsQYHA",
                    "type": "questions",
                    "attributes": {
                      "title": "O Me Salva! tem aulas de que áreas?",
                      "image": {
                        "url": "https://cdnqa.mesalva.com/uploads/image/integration.jpeg"
                      },
                      "answer": "Ensino Médio e ENEM, Engenharias e Ciências da saúde",
                      "created-by": "admin@mesalva.com",
                      "updated-by": "admin@integration.com"
                    }
                  }
                }


### Exibição de uma pergunta [GET]

+ Request (application/json)
    + Parameters
        + faq_id: `abcdefgh`
        + id: `OFd6bnxRqk1xJlsQYHA` (string, required)

+ Response 200 (application/json; charset=utf-8)

                {
                  "data": {
                    "id": "OFd6bnxRqk1xJlsQYHA",
                    "type": "questions",
                    "attributes": {
                      "title": "O Me Salva! tem aulas de que áreas?",
                      "image": {
                        "url": "https://cdnqa.mesalva.com/uploads/image/integration.jpeg"
                      },
                      "answer": "Ensino Médio e ENEM, Engenharias e Ciências da saúde",
                      "created-by": "admin@mesalva.com",
                      "updated-by": "admin@integration.com"
                    }
                  }
                }


### Remoção de uma pergunta [DELETE]
+ Request (application/json)
    + Parameters
        + faq_id: `abcdefgh` (string, required)
        + id: `OFd6bnxRqk1xJlsQYHA` (string, required)

    + Headers

                uid:  admin@integration.com
                access-token:  LkoOFd6bnxRqk1xJlsQYHA
                client:  WEB

+ Response 204

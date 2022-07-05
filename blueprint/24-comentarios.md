# Group Comentários

##  Comentários [/comments]
#### Este endpoint está deprecado.
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

### Criação de comentário em redação [POST]

+ Request (application/json)
    + Headers

                uid:  admin@integration.com
                access-token:  LkoOFd6bnxRqk1xJlsQYHA
                client:  WEB
                Content-Type: application/json; charset=utf-8

    + Body

                {
                  "essay_submission_id": "2m5BgWubSxGWxwXi",
                  "text": "Exatamente!"
                }

+ Response 201 (application/json; charset=utf-8)

                {
                  "data": {
                    "id": "zbXW4o_cT-NaFy1Mx4OTA",
                    "type": "comments",
                    "attributes": {
                      "text": "Exatamente!",
                      "author-name": null,
                      "created-at": "2017-02-12T08:44:42.174Z",
                      "updated-at": "2017-02-12T08:44:42.174Z",
                      "author-image": {
                        "url": null
                      }
                    },
                    "relationships": {
                      "commenter": {
                        "data": {
                          "id": "admin@integration.com",
                          "type": "admins"
                        }
                      }
                    }
                  }
                }


### Criação comentário em mídia [POST]

+ Request (application/json)
    + Headers

                uid:  admin@integration.com
                access-token:  LkoOFd6bnxRqk1xJlsQYHA
                client:  WEB

    + Body

                {
                  "permalink_slug": "enem-e-vestibulares/plano-de-estudos-1/matematica-e-suas-tecnologias/matematica/trigonometria/o-que-e-um-triangulo/video-basico-1",
                  "text": "Exatamente!"
                }

+ Response 201 (application/json; charset=utf-8)
                {
                  "data": {
                    "id": "HvhwKcNlR6PsEqiYX0sj_A",
                    "type": "comments",
                    "attributes": {
                      "text": "Exatamente!",
                      "author-name": null,
                      "created-at": "2017-02-12T08:44:42.174Z",
                      "updated-at": "2017-02-12T08:44:42.174Z",
                      "author-image": {
                        "url": null
                      }
                    },
                    "relationships": {
                      "commenter": {
                        "data": {
                          "id": "admin@integration.com",
                          "type": "admins"
                        }
                      }
                    }
                  }
                }



## Lista de Comentários em Mídia [/comments?permalink_slug={id}]
### Listagem de comentários [GET]

+ Request (application/json)
    + Parameters

        + id: `enem-e-vestibulares/plano-de-estudos-1/matematica-e-suas-tecnologias/matematica/trigonometria/o-que-e-um-triangulo/video-basico-1` (string, required) - slug permalink

    + Headers

                uid:  admin@integration.com
                access-token:  LkoOFd6bnxRqk1xJlsQYHA
                client:  WEB

+ Response 200 (application/json; charset=utf-8)
    + Body

                {
                  "data": [{
                    "id": "IntErN41n0T3",
                    "type": "comments",
                    "attributes": {
                      "text": "Internal note",
                      "author-name": null,
                      "created-at": "2017-02-12T08:44:42.174Z",
                      "updated-at": "2017-02-12T08:44:42.174Z",
                      "author-image": {
                        "url": null
                      }
                    },
                    "relationships": {
                      "commenter": {
                        "data": {
                          "id": "admin@integration.com",
                          "type": "admins"
                        }
                      }
                    }
                  }, {
                    "id": "zbXW4o_cT-NaFy1Mx4OTA",
                    "type": "comments",
                    "attributes": {
                      "text": "Exatamente!",
                      "author-name": null,
                      "created-at": "2017-02-12T08:44:42.174Z",
                      "updated-at": "2017-02-12T08:44:42.174Z",
                      "author-image": {
                        "url": null
                      }
                    },
                    "relationships": {
                      "commenter": {
                        "data": {
                          "id": "admin@integration.com",
                          "type": "admins"
                        }
                      }
                    }
                  }, {
                    "id": "HvhwKcNlR6PsEqiYX0sj_A",
                    "type": "comments",
                    "attributes": {
                      "text": "Exatamente!",
                      "author-name": null,
                      "created-at": "2017-02-12T08:44:42.174Z",
                      "updated-at": "2017-02-12T08:44:42.174Z",
                      "author-image": {
                        "url": null
                      }
                    },
                    "relationships": {
                      "commenter": {
                        "data": {
                          "id": "admin@integration.com",
                          "type": "admins"
                        }
                      }
                    }
                  }, {
                    "id": "lJ0nP6UoPDtcPUouhkYvJQ",
                    "type": "comments",
                    "attributes": {
                      "text": "Acesso congelado porque entrou de férias",
                      "author-name": null,
                      "created-at": "2017-02-12T08:44:42.174Z",
                      "updated-at": "2017-02-12T08:44:42.174Z",
                      "author-image": {
                        "url": null
                      }
                    },
                    "relationships": {
                      "commenter": {
                        "data": {
                          "id": "admin@integration.com",
                          "type": "admins"
                        }
                      }
                    }
                  }],
                  "links": {
                    "self": "http://127.0.0.1:3001/comments?page%5Bnumber%5D=1\u0026page%5Bsize%5D=20\u0026permalink_slug=enem-e-vestibulares%2Fplano-de-estudos-1%2Fmatematica-e-suas-tecnologias%2Fmatematica%2Ftrigonometria%2Fo-que-e-um-triangulo%2Fvideo-basico-1",
                    "first": "http://127.0.0.1:3001/comments?page%5Bnumber%5D=1\u0026page%5Bsize%5D=20\u0026permalink_slug=enem-e-vestibulares%2Fplano-de-estudos-1%2Fmatematica-e-suas-tecnologias%2Fmatematica%2Ftrigonometria%2Fo-que-e-um-triangulo%2Fvideo-basico-1",
                    "prev": null,
                    "next": null,
                    "last": "http://127.0.0.1:3001/comments?page%5Bnumber%5D=1\u0026page%5Bsize%5D=20\u0026permalink_slug=enem-e-vestibulares%2Fplano-de-estudos-1%2Fmatematica-e-suas-tecnologias%2Fmatematica%2Ftrigonometria%2Fo-que-e-um-triangulo%2Fvideo-basico-1"
                  }
                }


## Comentário [/comments/{id}]
### Atualização de um comentários [PUT]
+ Parameters
    + id: `Token` (string, required) - Id do comentário

+ Request (application/json)
    + Body

                { "text": "Exatamente: 3.14159265359" }

    + Headers

                uid:  admin@integration.com
                access-token:  LkoOFd6bnxRqk1xJlsQYHA
                client:  WEB

+ Response 200 (application/json; charset=utf-8)
    + Body

                {
                  "data": {
                    "id": "Token",
                    "type": "comments",
                    "attributes": {
                      "text": "Exatamente: 3.14159265359",
                      "author-name": null,
                      "created-at": "2017-02-12T08:44:42.174Z",
                      "updated-at": "2017-02-12T08:44:42.174Z",
                      "author-image": {
                        "url": null
                      }
                    },
                    "relationships": {
                      "commenter": {
                        "data": {
                          "id": "admin@integration.com",
                          "type": "admins"
                        }
                      }
                    }
                  }
                }

##  Notas Internas [/internal_notes]
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

## Exibição de notas Internas [/internal_notes?user_uid=user@integration.com]
### Todas as notas de um usuário [GET]
##### As notas vêm ordenadas de forma descrescente por data

+ Request (application/json)
    + Headers

                uid:  admin@integration.com
                access-token:  LkoOFd6bnxRqk1xJlsQYHA
                client:  WEB

+ Response 200 (application/json; charset=utf-8)
    + Body

                {
                  "data": [{
                    "id": "lJ0nP6UoPDtcPUouhkYvJQ",
                    "type": "comments",
                    "attributes": {
                      "text": "Acesso congelado porque entrou de férias",
                      "author-name": null,
                      "created-at": "2017-02-12T08:44:42.174Z",
                      "updated-at": "2017-02-12T08:44:42.174Z",
                      "author-image": {
                        "url": null
                      }
                    },
                    "relationships": {
                      "commenter": {
                        "data": {
                          "id": "admin@integration.com",
                          "type": "admins"
                        }
                      }
                    }
                  }, {
                    "id": "IntErN41n0T3",
                    "type": "comments",
                    "attributes": {
                      "text": "Internal note",
                      "author-name": null,
                      "created-at": "2017-02-12T08:44:42.174Z",
                      "updated-at": "2017-02-12T08:44:42.174Z",
                      "author-image": {
                        "url": null
                      }
                    },
                    "relationships": {
                      "commenter": {
                        "data": {
                          "id": "admin@integration.com",
                          "type": "admins"
                        }
                      }
                    }
                  }],
                  "links": {
                    "self": "http://127.0.0.1:3001/internal_notes?page%5Bnumber%5D=1\u0026page%5Bsize%5D=20\u0026user_uid=user%40integration.com",
                    "first": "http://127.0.0.1:3001/internal_notes?page%5Bnumber%5D=1\u0026page%5Bsize%5D=20\u0026user_uid=user%40integration.com",
                    "prev": null,
                    "next": null,
                    "last": "http://127.0.0.1:3001/internal_notes?page%5Bnumber%5D=1\u0026page%5Bsize%5D=20\u0026user_uid=user%40integration.com"
                  }
                }

## Criação de notas Internas [/internal_notes]
### Criar notas internas sobre um usuário [POST]

+ Request (application/json)
    + Headers

                uid:  admin@integration.com
                access-token:  LkoOFd6bnxRqk1xJlsQYHA
                client:  WEB

    + Body

                {
                  "text": "Acesso congelado porque entrou de férias",
                  "user_uid": "user@integration.com"
                }


+ Response 201 (application/json; charset=utf-8)
    + Body

                {
                  "data": {
                    "id": "lJ0nP6UoPDtcPUouhkYvJQ",
                    "type": "comments",
                    "attributes": {
                      "text": "Acesso congelado porque entrou de férias",
                      "author-name": null,
                      "created-at": "2017-02-12T08:44:42.174Z",
                      "updated-at": "2017-02-12T08:44:42.174Z",
                      "author-image": {
                        "url": null
                      }
                    },
                    "relationships": {
                      "commenter": {
                        "data": {
                          "id": "admin@integration.com",
                          "type": "admins"
                        }
                      }
                    }
                  }
                }

## Alteração de notas Internas [/internal_notes/{id}]
### Atualizar notas internas sobre um usuário [PUT]

+ Parameters
    + id: `IntErN41n0T3` (string, required) - Id do comentário

+ Request (application/json)
    + Headers

                uid:  admin@integration.com
                access-token:  LkoOFd6bnxRqk1xJlsQYHA
                client:  WEB

    + Body

                { "text": "Acesso congelado porque entrou de férias" }

+ Response 200 (application/json; charset=utf-8)
    + Body

                {
                  "data": {
                    "id": "IntErN41n0T3",
                    "type": "comments",
                    "attributes": {
                      "text": "Acesso congelado porque entrou de férias",
                      "author-name": null,
                      "created-at": "2017-02-12T08:44:42.174Z",
                      "updated-at": "2017-02-12T08:44:42.174Z",
                      "author-image": {
                        "url": null
                      }
                    },
                    "relationships": {
                      "commenter": {
                        "data": {
                          "id": "admin@integration.com",
                          "type": "admins"
                        }
                      }
                    }
                  }
                }

### Remoção de uma nota interna [DELETE]

+ Request (application/json)
    + Parameters
        + id: `IntErN41n0T3` (string, required)

    + Headers

                uid:  admin@integration.com
                access-token:  LkoOFd6bnxRqk1xJlsQYHA
                client:  WEB

+ Response 204

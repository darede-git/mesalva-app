# Group Conteúdos

## Novo Node [/nodes]
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


### Criação de node na hierarquia de conteúdo [POST]

+ Request (application/json)
    + Body

                {
                  "name": "Engenharia",
                  "node_type": "education_segment",
                  "image": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP4z8DwHwAFAAH/VscvDQAAAABJRU5ErkJggg==",
                  "video": "https://www.youtube.com/watch?v=Es-SdyJi2Rc",
                  "color_hex": "ED4343"
                }

    + Headers

                uid:  admin@integration.com
                access-token:  LkoOFd6bnxRqk1xJlsQYHA
                client:  WEB

+ Response 201 (application/json; charset=utf-8)
    + Body

                {
                  "data": {
                    "id": "16",
                    "type": "nodes",
                    "attributes": {
                      "name": "Engenharia",
                      "slug": "engenharia",
                      "description": null,
                      "image": {
                        "url": "https://cdnqa.mesalva.com/uploads/node/image/integration.png"
                      },
                      "video": "https://www.youtube.com/watch?v=Es-SdyJi2Rc",
                      "color-hex": "ED4343",
                      "created-by": "admin@integration.com",
                      "updated-by": null,
                      "node-type": "education_segment",
                      "suggested-to": null,
                      "pre-requisite": null,
                      "children": [],
                      "parent": null,
                      "active": true
                    },
                    "relationships": {
                      "media": {
                        "data": []
                      },
                      "node-modules": {
                        "data": []
                      }
                    }
                  }
                }


## Nodes [/nodes/{id}]
<!--### Atualização de node na hierarquia de conteúdo [PUT]

+ Request (application/json)
    + Parameters
        + id: `1` (number, required) - Id do node

    + Body

                {
                  "name": "Matemática",
                  "node_type": "education_segment",
                  "color_hex": "ED4343"
                }

    + Headers

                uid:  admin@integration.com
                access-token:  LkoOFd6bnxRqk1xJlsQYHA
                client:  WEB

+ Response 200 (application/json; charset=utf-8)

                {
                  "data": {
                    "id": "1",
                    "type": "nodes",
                    "attributes": {
                      "name": "Matemática",
                      "slug": "matematica",
                      "description": "Me Salva",
                      "image": {
                        "url": null
                      },
                      "video": null,
                      "color-hex": "ED4343",
                      "created-by": null,
                      "updated-by": "admin@integration.com",
                      "node-type": "education_segment",
                      "suggested-to": null,
                      "pre-requisite": null,
                      "children": [{
                        "id": 2,
                        "name": "Enem e Vestibulares",
                        "slug": "enem-e-vestibulares",
                        "image": {
                          "url": null
                        }
                      }, {
                        "id": 14,
                        "name": "New Education Segment",
                        "slug": "new-education-segment",
                        "image": {
                          "url": null
                        }
                      }],
                      "parent": null,
                      "active": true
                    },
                    "relationships": {
                      "media": {
                        "data": []
                      },
                      "node-modules": {
                        "data": []
                      }
                    }
                  }
                }
-->

### Vínculo de node_modules em node [PUT]

+ Request (application/json)
    + Parameters
        + id: `4` (number, required) - Id do node

    + Body

                {
                  "node_module_ids": [2,1]
                }

    + Headers

                uid:  admin@integration.com
                access-token:  LkoOFd6bnxRqk1xJlsQYHA
                client:  WEB

+ Response 200 (application/json; charset=utf-8)
    + Body

                {
                  "data": {
                    "id": "4",
                    "type": "nodes",
                    "attributes": {
                      "name": "Matemática e suas tecnologias",
                      "slug": "matematica-e-suas-tecnologias",
                      "description": null,
                      "image": {
                        "url": null
                      },
                      "video": null,
                      "color-hex": "ED4343",
                      "created-by": null,
                      "updated-by": "admin@integration.com",
                      "node-type": "area",
                      "suggested-to": null,
                      "pre-requisite": null,
                      "children": [{
                        "id": 5,
                        "name": "Matemática",
                        "slug": "matematica",
                        "image": {
                          "url": null
                        }
                      }, {
                        "id": 10,
                        "name": "Materias",
                        "slug": "materias",
                        "image": {
                          "url": null
                        }
                      }],
                      "parent": {
                        "id": 3,
                        "name": "Plano de estudos 1",
                        "slug": "plano-de-estudos-1",
                        "image": {
                          "url": null
                        }
                      },
                      "active": true
                    },
                    "relationships": {
                      "media": {
                        "data": []
                      },
                      "node-modules": {
                        "data": [{
                          "id": "2",
                          "type": "node-modules"
                        }, {
                          "id": "1",
                          "type": "node-modules"
                        }]
                      }
                    }
                  }
                }


## Novo Node Module [/node_modules]
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


### Criação de node module na hierarquia de conteúdo [POST]

+ Request (application/json)
    + Body

                {
                  "instructor_uid": "teacher@integration.com",
                  "instructor_type": "Teacher",
                  "name": "Álgebra Linear",
                  "code": "alg01",
                  "description": "Álgebra linear é um ramo da matemática que surgiu do estudo detalhado de sistemas de equações lineares, sejam elas algébricas ou diferenciais.",
                  "suggested_to": "Estudantes da disciplina de matemática",
                  "pre_requisite": "Saber ler e escrever",
                  "position": 1
                }

    + Headers

                uid:  admin@integration.com
                access-token:  LkoOFd6bnxRqk1xJlsQYHA
                client:  WEB

+ Response 201 (application/json; charset=utf-8)
    + Body

                {
                  "data": {
                    "id": "6",
                    "type": "node-modules",
                    "attributes": {
                      "name": "Álgebra Linear",
                      "slug": "algebra-linear",
                      "code": "alg01",
                      "description": "Álgebra linear é um ramo da matemática que surgiu do estudo detalhado de sistemas de equações lineares, sejam elas algébricas ou diferenciais.",
                      "suggested-to": "Estudantes da disciplina de matemática",
                      "pre-requisite": "Saber ler e escrever",
                      "image": {
                        "url": null
                      },
                      "created-by": "admin@integration.com",
                      "updated-by": null,
                      "active": true,
                      "instructor": {
                        "uid": "teacher@integration.com",
                        "name": null,
                        "image": {
                          "url": null
                        },
                        "description": null
                      },
                      "relevancy": 1,
                      "position": 1,
                      "node-module-type": "default"
                    },
                    "relationships": {
                      "media": {
                        "data": []
                      },
                      "items": {
                        "data": []
                      },
                      "nodes": {
                        "data": []
                      }
                    }
                  }
                }


## Node Module [/node_modules/{id}]
### Atualização de node module na hierarquia de conteúdo [PUT]

+ Request (application/json)
    + Parameters
        + id: `1` (number, required) - Id do node module

    + Body

                {
                  "instructor_uid": "admin@integration.com",
                  "instructor_type": "Admin",
                  "name": "Álgebra Linear e suas Aplicações"
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
                    "type": "node-modules",
                    "attributes": {
                      "name": "Álgebra Linear e suas Aplicações",
                      "slug": "algebra-linear",
                      "code": "alg01",
                      "description": "Álgebra linear é um ramo da matemática que surgiu do estudo detalhado de sistemas de equações lineares, sejam elas algébricas ou diferenciais.",
                      "suggested-to": "Estudantes da disciplina de matemática",
                      "pre-requisite": "Saber ler e escrever",
                      "image": {
                        "url": null
                      },
                      "created-by": null,
                      "updated-by": "admin@integration.com",
                      "active": null,
                      "instructor": {
                        "uid": "admin@integration.com",
                        "name": null,
                        "image": {
                          "url": null
                        },
                        "description": null
                      }
                    },
                    "relationships": {
                      "media": {
                        "data": []
                      },
                      "items": {
                        "data": [{
                          "id": "1",
                          "type": "items"
                        }]
                      },
                      "nodes": {
                        "data": [{
                          "id": "4",
                          "type": "nodes"
                        }]
                      }
                    }
                  }
                }


## Novo Item [/items]
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


### Criação de item na hierarquia de conteúdo [POST]

+ Request (application/json)
    + Body

                {
                  "name": "Básico",
                  "code": "BAS",
                  "description": "item basico",
                  "free": "true",
                  "active": "true",
                  "item_type": "text",
                  "downloadable": "true"
                }

    + Headers

                uid:  admin@integration.com
                access-token:  LkoOFd6bnxRqk1xJlsQYHA
                client:  WEB

+ Response 201 (application/json; charset=utf-8)
    + Body

                {
                  "data": {
                    "id": "2",
                    "type": "items",
                    "attributes": {
                      "name": "Básico",
                      "slug": "basico",
                      "description": "item basico",
                      "free": true,
                      "active": true,
                      "code": "BAS",
                      "created-by": "admin@integration.com",
                      "updated-by": null,
                      "item-type": "text",
                      "downloadable": "true"
                    },
                    "relationships": {
                      "media": {
                        "data": []
                      },
                      "node-modules": {
                        "data": []
                      }
                    }
                  }
                }


<!--## Items [/items/{id}]
### Atualização de item na hierarquia de conteúdo [PUT]

+ Request (application/json)
    + Parameters
        + id: `1` (number, required) - Id do item

    + Body

                {
                  "name": "Hiper mega avançado",
                  "tag": ["Básico"]
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
                    "type": "items",
                    "attributes": {
                      "name": "Hiper mega avançado",
                      "slug": "basico",
                      "description": "item basico",
                      "free": true,
                      "active": true,
                      "code": "BAS",
                      "created-by": "1",
                      "updated-by": "admin@integration.com",
                      "item-type": "lesson",
                      "downloadable": "true",
                      "tag": ["Básico"]
                    },
                    "relationships": {
                      "media": {
                        "data": [{
                          "id": "1",
                          "type": "media"
                        }, {
                          "id": "2",
                          "type": "media"
                        }]
                      },
                      "node-modules": {
                        "data": [{
                          "id": "1",
                          "type": "node-modules"
                        }]
                      }
                    }
                  }
                }
-->

## Media [/media]
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


### Criação de uma midia do tipo video [POST]
+ Request (application/json)
    + Body

                {
                  "name": "Video 01",
                  "medium_type": "video",
                  "video_id": "123456QWewQ",
                  "seconds_duration": 600,
                  "provider": "samba",
                  "active": "true"
                }

    + Headers

                uid:  admin@integration.com
                access-token:  LkoOFd6bnxRqk1xJlsQYHA
                client:  WEB

+ Response 201 (application/json; charset=utf-8)
    + Body

                {
                  "data": {
                    "id": "3",
                    "type": "media",
                    "attributes": {
                      "name": "Video 01",
                      "description": null,
                      "attachment": {
                        "url": null
                      },
                      "seconds-duration": 600,
                      "provider": "samba",
                      "correction": null,
                      "code": null,
                      "active": true,
                      "matter": null,
                      "subject": null,
                      "difficulty": null,
                      "concourse": null,
                      "created-by": 11,
                      "updated-by": null,
                      "medium-type": "video",
                      "medium-text": null,
                      "video-id": "123456QWewQ"
                    },
                    "relationships": {
                      "nodes": {
                        "data": []
                      },
                      "items": {
                        "data": []
                      },
                      "node-modules": {
                        "data": []
                      },
                      "answers": {
                        "data": []
                      }
                    }
                  }
                }


### Criação de uma midia do tipo exercicio [POST]
+ Request (application/json)
    + Body

                {
                  "name": "Exercicio 01",
                  "description": "Qual a resposta certa?",
                  "medium_type": "fixation_exercise",
                  "correction": "É a reposta 1 porque...",
                  "audit_status": "reviewed",
                  "active": "true",
                  "difficulty": 3,
                  "answers_attributes": [{
                    "text": "Alternativa 1",
                    "correct": "true",
                    "active": "true"
                  }, {
                    "text": "Alternativa 2",
                    "correct": "false",
                    "active": "true"
                  }, {
                    "text": "Alternativa 3",
                    "correct": "false",
                    "active": "true"
                  }, {
                    "text": "Alternativa 4",
                    "correct": "false",
                    "active": "true"
                  }, {
                    "text": "Alternativa 5",
                    "correct": "false",
                    "active": "true"
                  }]
                }

    + Headers

                uid:  admin@integration.com
                access-token:  LkoOFd6bnxRqk1xJlsQYHA
                client:  WEB

+ Response 201 (application/json; charset=utf-8)
    + Body

                {
                  "data": {
                    "id": "4",
                    "type": "media",
                    "attributes": {
                      "name": "Exercicio 01",
                      "description": "Qual a resposta certa?",
                      "attachment": {
                        "url": null
                      },
                      "seconds-duration": null,
                      "provider": null,
                      "correction": "É a reposta 1 porque...",
                      "code": null,
                      "active": true,
                      "matter": null,
                      "subject": null,
                      "difficulty": 3,
                      "concourse": null,
                      "created-by": 11,
                      "updated-by": null,
                      "medium-type": "fixation_exercise",
                      "medium-text": null,
                      "video-id": null
                    },
                    "relationships": {
                      "nodes": {
                        "data": []
                      },
                      "items": {
                        "data": []
                      },
                      "node-modules": {
                        "data": []
                      },
                      "answers": {
                        "data": [{
                          "id": "6",
                          "type": "answers"
                        }, {
                          "id": "7",
                          "type": "answers"
                        }, {
                          "id": "8",
                          "type": "answers"
                        }, {
                          "id": "9",
                          "type": "answers"
                        }, {
                          "id": "10",
                          "type": "answers"
                        }]
                      }
                    }
                  },
                  "included": [{
                    "id": "6",
                    "type": "answers",
                    "attributes": {
                      "text": "Alternativa 1",
                      "explanation": null,
                      "correct": true,
                      "active": true
                    }
                  }, {
                    "id": "7",
                    "type": "answers",
                    "attributes": {
                      "text": "Alternativa 2",
                      "explanation": null,
                      "correct": false,
                      "active": true
                    }
                  }, {
                    "id": "8",
                    "type": "answers",
                    "attributes": {
                      "text": "Alternativa 3",
                      "explanation": null,
                      "correct": false,
                      "active": true
                    }
                  }, {
                    "id": "9",
                    "type": "answers",
                    "attributes": {
                      "text": "Alternativa 4",
                      "explanation": null,
                      "correct": false,
                      "active": true
                    }
                  }, {
                    "id": "10",
                    "type": "answers",
                    "attributes": {
                      "text": "Alternativa 5",
                      "explanation": null,
                      "correct": false,
                      "active": true
                    }
                  }]
                }


### Criação de uma midia do tipo pdf [POST]
+ Request (application/json)
    + Body

                {
                  "name": "Arquivo pdf",
                  "medium_type": "pdf",
                  "active": "true",
                  "attachment": "data:application/pdf;base64,JVBERi0xLjYKJeTjz9IKMSAwIG9iagpbL1BERi9JbWFnZUIvSW1hZ2VDL0ltYWdlSS9UZXh0XQplbmRvYmoKNCAwIG9iago8PC9MZW5ndGggNSAwIFIKL0ZpbHRlci9GbGF0ZURlY29kZQo+PgpzdHJlYW0KeJwDAAAAAAEKZW5kc3RyZWFtCmVuZG9iago1IDAgb2JqCjgKZW5kb2JqCjcgMCBvYmoKPDwvU3VidHlwZS9JbWFnZQovV2lkdGggMQovSGVpZ2h0IDEKL0JpdHNQZXJDb21wb25lbnQgOAovQ29sb3JTcGFjZS9EZXZpY2VSR0IKL0ZpbHRlci9GbGF0ZURlY29kZQovTGVuZ3RoIDggMCBSCj4+CnN0cmVhbQp4nPvPwAAAAwABAAplbmRzdHJlYW0KZW5kb2JqCjggMCBvYmoKMTEKZW5kb2JqCjkgMCBvYmoKPDwvTGVuZ3RoIDEwIDAgUgovRmlsdGVyL0ZsYXRlRGVjb2RlCj4+CnN0cmVhbQp4nCvkMlQwAEJDBWMDUz1TBWNLEJmcy6XvaaDgks8VyAUAcc8GtwplbmRzdHJlYW0KZW5kb2JqCjEwIDAgb2JqCjM4CmVuZG9iagoxMSAwIG9iagpbIDQgMCBSIDkgMCBSXQplbmRvYmoKMTIgMCBvYmoKPDwvUHJvY1NldCAxIDAgUgovWE9iamVjdDw8L0kwIDcgMCBSCj4+Cj4+CmVuZG9iagoxMyAwIG9iago8PC9TdWJqZWN0IChHZW5lcmF0ZWQgb24gTm92ZW1iZXIgMTcsIDIwMTYsIDQ6MTMgcG0pCi9UaXRsZSAoQ29udmVydCBKUEcgdG8gUERGIG9ubGluZSAtIGNvbnZlcnQtanBnLXRvLXBkZi5uZXQpCi9BdXRob3IgKGNvbnZlcnQtanBnLXRvLXBkZi5uZXQpCi9DcmVhdG9yIChjb252ZXJ0LWpwZy10by1wZGYubmV0KQovQ3JlYXRpb25EYXRlIChEOjIwMTYxMTE3MTYxMzE0KzAxJzAwJykKL1Byb2R1Y2VyIChQREZsaWIgTGl0ZSA3LjAuNXAzIFwoUEhQNS9MaW51eC14ODZfNjRcKSkKPj4KZW5kb2JqCjMgMCBvYmoKPDwvVHlwZS9QYWdlCi9QYXJlbnQgMiAwIFIKL0NvbnRlbnRzIDExIDAgUgovUmVzb3VyY2VzIDEyIDAgUgovTWVkaWFCb3hbMCAwIDYxMiA3OTJdCj4+CmVuZG9iagoyIDAgb2JqCjw8L1R5cGUvUGFnZXMKL0NvdW50IDEKL0tpZHNbIDMgMCBSXT4+CmVuZG9iagoxNCAwIG9iago8PC9UeXBlL0NhdGFsb2cKL1BhZ2VzIDIgMCBSCj4+CmVuZG9iagp4cmVmCjAgMTUKMDAwMDAwMDAwNiA2NTUzNSBmIAowMDAwMDAwMDE1IDAwMDAwIG4gCjAwMDAwMDA5NTMgMDAwMDAgbiAKMDAwMDAwMDg1MCAwMDAwMCBuIAowMDAwMDAwMDYzIDAwMDAwIG4gCjAwMDAwMDAxNDMgMDAwMDAgbiAKMDAwMDAwMDAwMCAwMDAwMSBmIAowMDAwMDAwMTYwIDAwMDAwIG4gCjAwMDAwMDAzMTkgMDAwMDAgbiAKMDAwMDAwMDMzNyAwMDAwMCBuIAowMDAwMDAwNDQ4IDAwMDAwIG4gCjAwMDAwMDA0NjcgMDAwMDAgbiAKMDAwMDAwMDQ5OCAwMDAwMCBuIAowMDAwMDAwNTU3IDAwMDAwIG4gCjAwMDAwMDEwMDcgMDAwMDAgbiAKdHJhaWxlcgo8PC9TaXplIDE1Ci9Sb290IDE0IDAgUgovSW5mbyAxMyAwIFIKL0lEWzxFMzdBRUE4ODY4NUUwNDVEODgxQkZFQUFGRDA3MDJERD48RTM3QUVBODg2ODVFMDQ1RDg4MUJGRUFBRkQwNzAyREQ+XQo+PgpzdGFydHhyZWYKMTA1NQolJUVPRgo="
                }

    + Headers

                uid:  admin@integration.com
                access-token:  LkoOFd6bnxRqk1xJlsQYHA
                client:  WEB


+ Response 201 (application/json; charset=utf-8)
    + Body

                {
                  "data": {
                    "id": "6",
                    "type": "media",
                    "attributes": {
                      "name": "Arquivo pdf",
                      "description": null,
                      "attachment": {
                        "url": "https://cdnqa.mesalva.com/uploads/medium/attachment/integration.pdf"
                      },
                      "seconds-duration": null,
                      "provider": null,
                      "correction": null,
                      "code": null,
                      "active": true,
                      "matter": null,
                      "subject": null,
                      "difficulty": null,
                      "concourse": null,
                      "created-by": 11,
                      "updated-by": null,
                      "medium-type": "pdf",
                      "medium-text": null,
                      "video-id": null
                    },
                    "relationships": {
                      "nodes": {
                        "data": []
                      },
                      "items": {
                        "data": []
                      },
                      "node-modules": {
                        "data": []
                      },
                      "answers": {
                        "data": []
                      }
                    }
                  }
                }

## Comentários em mídias [/media/{permalink_slug}/comments]
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

### Criação comentário em mídia [POST]

+ Request (application/json)
    + Parameters
        + permalink_slug: `enem-e-vestibulares/plano-de-estudos-1/matematica-e-suas-tecnologias/matematica/trigonometria/o-que-e-um-triangulo/video-basico-1` (string, required) - Slug do permalink

    + Headers

                uid:  user@integration.com
                access-token:  kaTuL76JKSqWb9PmwnQYQA
                client:  WEB

    + Body

                {
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
                          "id": "user@integration.com",
                          "type": "admins"
                        }
                      }
                    }
                  }
                }

### Listagem de comentários de uma mídia [GET]

+ Request (application/json)
    + Parameters

        + permalink_slug: `enem-e-vestibulares/plano-de-estudos-1/matematica-e-suas-tecnologias/matematica/trigonometria/o-que-e-um-triangulo/video-basico-1` (string, required) - slug permalink

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
                      "author-name": "User Test",
                      "created-at": "2017-02-12T08:44:42.174Z",
                      "updated-at": "2017-02-12T08:44:42.174Z",
                      "author-image": {
                        "url": "https://cdnqa.mesalva.com/uploads/user/image/integration.jpeg"
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
                      "author-name": "User Test",
                      "created-at": "2017-02-12T08:44:42.174Z",
                      "updated-at": "2017-02-12T08:44:42.174Z",
                      "author-image": {
                        "url": "https://cdnqa.mesalva.com/uploads/user/image/integration.jpeg"
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
                      "author-name": "User Test",
                      "created-at": "2017-02-12T08:44:42.174Z",
                      "updated-at": "2017-02-12T08:44:42.174Z",
                      "author-image": {
                        "url": "https://cdnqa.mesalva.com/uploads/user/image/integration.jpeg"
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
                      "author-name": "User Test",
                      "created-at": "2017-02-12T08:44:42.174Z",
                      "updated-at": "2017-02-12T08:44:42.174Z",
                      "author-image": {
                        "url": "https://cdnqa.mesalva.com/uploads/user/image/integration.jpeg"
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

## Edição de comentários em mídias [/media/{permalink_slug}/comments/{id}]
### Métodos HTTP disponíveis [OPTIONS]

+ Request
    + Headers

                Origin:  https://www.mesalva.com
                Access-Control-Request-Method:  POST


+ Response 200 (text/plain)
    + Headers

                Access-Control-Allow-Origin: http://mesalva.com
                Access-Control-Allow-Methods: HEAD, OPTIONS, GET, POST, PUT
                Access-Control-Expose-Headers: access-token, expiry, token-type, uid, client, x-dateaccess-token, expiry, token-type, uid, client, x-date
                Access-Control-Max-Age: 1728000
                Access-Control-Allow-Headers: X-Requested-With
                Content-Length: 0

### Atualização de comentários [PUT]

+ Request (application/json)
    + Parameters
        + permalink_slug: `enem-e-vestibulares/plano-de-estudos-1/matematica-e-suas-tecnologias/matematica/trigonometria/o-que-e-um-triangulo/video-basico-1` (string, required) - Slug do permalink
        + id: `Token` (string, required)

    + Headers

                uid:  admin@integration.com
                access-token:  LkoOFd6bnxRqk1xJlsQYHA
                client:  WEB

    + Body
                {
                  "text": "Exatamente!"
                }

+ Response 200 (application/json; charset=utf-8)
    + Body

                {
                  "data": {
                    "id": "Token",
                    "type": "comments",
                    "attributes": {
                      "text": "Exatamente!",
                      "author-name": "Novo nome com atributo",
                      "created-at": "2017-02-12T08:44:42.174Z",
                      "updated-at": "2017-02-12T08:44:42.174Z",
                      "author-image": {
                        "url": "https://cdnqa.mesalva.com/uploads/user/image/integration.jpeg"
                      }
                    },
                    "relationships": {
                      "commenter": {
                        "data": {
                          "id": "user@integration.com",
                          "type": "users"
                        }
                      }
                    }
                  }
                }


<!--## Medium [/media/{id}{?permalink_slug}]
### Atualização de media na hierarquia de conteúdo [PUT]

+ Request (application/json)
    + Parameters
        + id: `1` (number, required) - Id do media
        + permalink_slug: (string, optional)

    + Body

                {
                  "name": "Exercício 666",
                  "description": "Explicação do copo que desaparece!",
                  "correction": "Algo errado não esta certo!",
                  "code": "E039",
                  "active": "true",
                  "matter": "Logarítimo",
                  "subject": "Algebra Linear",
                  "difficulty": 3,
                  "concourse": "Enem e Vestibulares",
                  "tag": ["Matemática", "Algebra", "Fácil"]
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
                    "type": "media",
                    "attributes": {
                      "name": "Exercício 666",
                      "description": "Explicação do copo que desaparece!",
                      "attachment": {
                        "url": null
                      },
                      "seconds-duration": 15,
                      "provider": "youtube",
                      "correction": "Algo errado não esta certo!",
                      "code": "E039",
                      "active": true,
                      "matter": "Logarítimo",
                      "subject": "Algebra Linear",
                      "difficulty": 3,
                      "concourse": "Enem e Vestibulares",
                      "created-by": null,
                      "updated-by": "admin@integration.com",
                      "medium-type": "video",
                      "medium-text": null,
                      "video-id": "Vw8R8gCNMoI",
                      "tag": ["Matemática", "Algebra", "Fácil"]
                    },
                    "relationships": {
                      "nodes": {
                        "data": []
                      },
                      "items": {
                        "data": [{
                          "id": "1",
                          "type": "items"
                        }]
                      },
                      "node-modules": {
                        "data": []
                      },
                      "answers": {
                        "data": []
                      }
                    }
                  }
                }


### Visualização de mídia [GET]

+ Parameters
    + id: `video-basico-1` (string, required) - Id da midia
    + permalink_slug: `enem-e-vestibulares/plano-de-estudos-1/matematica-e-suas-tecnologias/matematica/trigonometria/o-que-e-um-triangulo/video-basico-1` (string, optional)

+ Request (application/json)
    + Headers

                uid:  user@integration.com
                access-token:  kaTuL76JKSqWb9PmwnQYQA
                client:  WEB

+ Response 200 (application/json; charset=utf-8)
    + Body

                {
                  "data": {
                    "id": "1",
                    "type": "media",
                    "attributes": {
                      "name": "Exercício 666",
                      "description": "Explicação do copo que desaparece!",
                      "attachment": {
                        "url": null
                      },
                      "seconds-duration": 15,
                      "provider": "youtube",
                      "correction": "Algo errado não esta certo!",
                      "code": "E039",
                      "active": true,
                      "matter": "Logarítimo",
                      "subject": "Algebra Linear",
                      "difficulty": 3,
                      "concourse": "Enem e Vestibulares",
                      "slug": "video-basico",
                      "medium-type": "video",
                      "medium-text": null,
                      "video-id": "Vw8R8gCNMoI"
                    },
                    "relationships": {
                      "answers": {
                        "data": []
                      }
                    }
                  }
                }
-->

## Imagens genéricas [/images]
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


### Criação de nova imagem com upload [POST]

<!-- 
+ Request (application/json)
    + Body

                {
                  "image": {
                    "image": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP4z8DwHwAFAAH/VscvDQAAAABJRU5ErkJggg=="
                  }
                }

    + Headers

                uid:  admin@integration.com
                access-token:  LkoOFd6bnxRqk1xJlsQYHA
                client:  WEB

+ Response 201 (application/json; charset=utf-8)
    + Body

                {
                  "data": {
                    "id": "1",
                      "type": "images",
                      "attributes": {
                        "image": {
                          "url": "https://cdnqa.mesalva.com/uploads/image/integration.png",
                          "created-by": "admin@integration.com"
                        }
                      }
                  }
                } -->

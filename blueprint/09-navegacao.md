# Group Navegação

## Permalinks [/permalink_contents]
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


## Permalink [/permalink_contents/{id}]
### Permalink terminado em medium [GET]

+ Parameters
    + id: `enem-e-vestibulares/plano-de-estudos-1/matematica-e-suas-tecnologias/matematica/trigonometria/o-que-e-um-triangulo/video-basico-1` (string, required) - permalink_contents/{id}

+ Response 200 (application/json; charset=utf-8)
    + Body

              {
                "data": {
                  "id": "7",
                  "type": "permalinks",
                  "attributes": {
                    "slug": "enem-e-vestibulares/plano-de-estudos-1/matematica-e-suas-tecnologias/matematica/trigonometria/o-que-e-um-triangulo/video-basico-1",
                    "canonical-uri": null
                  }
                },
                "meta": {
                  "entities": [{
                    "id": 2,
                    "name": "Enem e Vestibulares",
                    "slug": "enem-e-vestibulares",
                    "color-hex": null,
                    "entity-type": "node",
                    "node-type": "education_segment"
                  }, {
                    "id": 3,
                    "name": "Plano de estudos 1",
                    "slug": "plano-de-estudos-1",
                    "color-hex": null,
                    "entity-type": "node",
                    "node-type": "study_plan"
                  }, {
                    "id": 4,
                    "name": "Matemática e suas tecnologias",
                    "slug": "matematica-e-suas-tecnologias",
                    "color-hex": "ED4343",
                    "entity-type": "node",
                    "node-type": "area"
                  }, {
                    "id": 5,
                    "name": "Matemática",
                    "slug": "matematica",
                    "color-hex": "ED4343",
                    "entity-type": "node",
                    "node-type": "area_subject"
                  }, {
                    "id": 1,
                    "name": "Trigonometria",
                    "slug": "trigonometria",
                    "entity-type": "node_module"
                  }, {
                    "id": 1,
                    "name": "O que é um triângulo?",
                    "slug": "o-que-e-um-triangulo",
                    "description": "item basico",
                    "free": true,
                    "active": true,
                    "code": "BAS",
                    "created-by": "1",
                    "updated-by": "1",
                    "item-type": "video",
                    "downloadable": true,
                    "tag": null,
                    "streaming-status": null,
                    "entity-type": "item",
                    "chat-token": null,
                    "media": [{
                      "slug": "video-basico-1",
                      "medium-type": "video"
                    }]
                  }, {
                    "id": 1,
                    "name": "Vídeo Basico 1",
                    "slug": "video-basico-1",
                    "entity-type": "medium"
                  }]
                }
              }


### Permalink terminado em item [GET]

+ Parameters
    + id: `enem-e-vestibulares/plano-de-estudos-1/matematica-e-suas-tecnologias/matematica/trigonometria/quem-foi-pitagoras` (string, required) - permalink_contents/{id}

+ Response 200 (application/json; charset=utf-8)
    + Body

                {
                  "data": {
                    "id": "7",
                    "type": "permalinks",
                    "attributes": {
                      "slug": "enem-e-vestibulares/plano-de-estudos-1/matematica-e-suas-tecnologias/matematica/trigonometria/o-que-e-um-triangulo/video-basico-1",
                      "canonical-uri": null
                    }
                  },
                  "meta": {
                    "entities": [{
                      "id": 2,
                      "name": "Enem e Vestibulares",
                      "slug": "enem-e-vestibulares",
                      "color-hex": null,
                      "entity-type": "node",
                      "node-type": "education_segment"
                    }, {
                      "id": 3,
                      "name": "Plano de estudos 1",
                      "slug": "plano-de-estudos-1",
                      "color-hex": null,
                      "entity-type": "node",
                      "node-type": "study_plan"
                    }, {
                      "id": 4,
                      "name": "Matemática e suas tecnologias",
                      "slug": "matematica-e-suas-tecnologias",
                      "color-hex": "ED4343",
                      "entity-type": "node",
                      "node-type": "area"
                    }, {
                      "id": 5,
                      "name": "Matemática",
                      "slug": "matematica",
                      "color-hex": "ED4343",
                      "entity-type": "node",
                      "node-type": "area_subject"
                    }, {
                      "id": 1,
                      "name": "Trigonometria",
                      "slug": "trigonometria",
                      "entity-type": "node_module"
                    }, {
                      "id": 1,
                      "name": "O que é um triângulo?",
                      "slug": "o-que-e-um-triangulo",
                      "description": "item basico",
                      "free": true,
                      "active": true,
                      "code": "BAS",
                      "created-by": "1",
                      "updated-by": "1",
                      "item-type": "video",
                      "downloadable": true,
                      "tag": null,
                      "streaming-status": null,
                      "entity-type": "item",
                      "chat-token": null,
                      "media": [{
                        "slug": "video-basico-1",
                        "medium-type": "video"
                      }]
                    }, {
                      "id": 1,
                      "name": "Vídeo Basico 1",
                      "slug": "video-basico-1",
                      "entity-type": "medium"
                    }]
                  }
                }


### Permalink terminado em node module [GET]

+ Parameters
    + id: `enem-e-vestibulares/plano-de-estudos-1/matematica-e-suas-tecnologias/matematica/trigonometria` (string, required) - permalink_contents/{id}

+ Response 200 (application/json; charset=utf-8)
    + Body

                {
                  "data": {
                    "id": "5",
                    "type": "permalinks",
                    "attributes": {
                      "slug": "enem-e-vestibulares/plano-de-estudos-1/matematica-e-suas-tecnologias/matematica/trigonometria",
                      "canonical-uri": null
                    }
                  },
                  "meta": {
                    "entities": [{
                      "id": 2,
                      "name": "Enem e Vestibulares",
                      "slug": "enem-e-vestibulares",
                      "color-hex": null,
                      "entity-type": "node",
                      "node-type": "education_segment"
                    }, {
                      "id": 3,
                      "name": "Plano de estudos 1",
                      "slug": "plano-de-estudos-1",
                      "color-hex": null,
                      "entity-type": "node",
                      "node-type": "study_plan"
                    }, {
                      "id": 4,
                      "name": "Matemática e suas tecnologias",
                      "slug": "matematica-e-suas-tecnologias",
                      "color-hex": "ED4343",
                      "entity-type": "node",
                      "node-type": "area"
                    }, {
                      "id": 5,
                      "name": "Matemática",
                      "slug": "matematica",
                      "color-hex": "ED4343",
                      "entity-type": "node",
                      "node-type": "subject"
                    }, {
                      "id": 1,
                      "name": "Trigonometria",
                      "slug": "trigonometria",
                      "code": "alg01",
                      "description": "Álgebra linear é um ramo da matemática que surgiu do estudo detalhado de sistemas de equações lineares, sejam elas algébricas ou diferenciais.",
                      "suggested-to": "Estudantes da disciplina de matemática",
                      "pre-requisite": "Saber ler e escrever",
                      "image": {
                        "url": null
                      },
                      "entity-type": "node_module",
                      "instructor": {
                        "uid": "teacher@integration.com",
                        "name": null,
                        "image": {
                          "url": null
                        },
                        "description": null
                      },
                      "items": [{
                        "id": 1,
                        "name": "O que é um triângulo?",
                        "slug": "o-que-e-um-triangulo",
                        "description": "item basico",
                        "free": true,
                        "active": true,
                        "code": "BAS",
                        "item-type": "video",
                        "entity-type": "item",
                        "downloadable": true
                      }, {
                        "id": 2,
                        "name": "Quem foi Pitagoras?",
                        "slug": "quem-foi-pitagoras",
                        "description": "item basico texto",
                        "free": true,
                        "active": true,
                        "code": "BAS",
                        "item-type": "text",
                        "entity-type": "item",
                        "downloadable": true
                      }, {
                        "id": 3,
                        "name": "Exercicios de trigo",
                        "slug": "exercicios-de-trigo",
                        "description": "item basico exercicio",
                        "free": true,
                        "active": true,
                        "code": "BAS",
                        "item-type": "fixation_exercise",
                        "entity-type": "item",
                        "downloadable": true
                      }],
                      "media": []
                    }]
                  }
                }


### Permalink terminado em node [GET]

+ Parameters
    + id: `enem-e-vestibulares/plano-de-estudos-1/matematica-e-suas-tecnologias/matematica` (string, required) - permalink_contents/{id}


+ Response 200 (application/json; charset=utf-8)
    + Body

                {
                  "data": {
                    "id": "4",
                    "type": "permalinks",
                    "attributes": {
                      "slug": "enem-e-vestibulares/plano-de-estudos-1/matematica-e-suas-tecnologias/matematica",
                      "canonical-uri": null
                    }
                  },
                  "meta": {
                    "entities": [{
                      "id": 2,
                      "name": "Enem e Vestibulares",
                      "slug": "enem-e-vestibulares",
                      "color-hex": null,
                      "entity-type": "node",
                      "node-type": "education_segment"
                    }, {
                      "id": 3,
                      "name": "Plano de estudos 1",
                      "slug": "plano-de-estudos-1",
                      "color-hex": null,
                      "entity-type": "node",
                      "node-type": "study_plan"
                    }, {
                      "id": 4,
                      "name": "Matemática e suas tecnologias",
                      "slug": "matematica-e-suas-tecnologias",
                      "color-hex": "ED4343",
                      "entity-type": "node",
                      "node-type": "area"
                    }, {
                      "id": 5,
                      "name": "Matemática",
                      "slug": "matematica",
                      "description": null,
                      "image": {
                        "url": null
                      },
                      "video": null,
                      "color-hex": "ED4343",
                      "created-by": null,
                      "updated-by": null,
                      "node-type": "area_subject",
                      "suggested-to": null,
                      "pre-requisite": null,
                      "children": [],
                      "entity-type": "node",
                      "node-modules": [{
                        "id": 1,
                        "name": "Trigonometria",
                        "slug": "trigonometria",
                        "code": "alg01",
                        "description": "Álgebra linear é um ramo da matemática que surgiu do estudo detalhado de sistemas de equações lineares, sejam elas algébricas ou diferenciais.",
                        "suggested-to": "Estudantes da disciplina de matemática",
                        "pre-requisite": "Saber ler e escrever",
                        "image": {
                          "url": null
                        },
                        "instructor": {
                          "uid": "teacher@integration.com",
                          "name": null,
                          "image": {
                            "url": null
                          },
                          "description": null
                        },
                        "node-module-type": "default"
                      }, {
                        "id": 2,
                        "name": "Álgebra Linear",
                        "slug": "algebra-linear",
                        "code": "alg01",
                        "description": "Álgebra linear é um ramo da matemática que surgiu do estudo detalhado de sistemas de equações lineares, sejam elas algébricas ou diferenciais.",
                        "suggested-to": "Estudantes da disciplina de matemática",
                        "pre-requisite": "Saber ler e escrever",
                        "image": {
                          "url": null
                        },
                        "instructor": {
                          "uid": "teacher@integration.com",
                          "name": null,
                          "image": {
                            "url": null
                          },
                          "description": null
                        },
                        "node-module-type": "default"
                      }],
                      "media": []
                    }]
                  }
                }

### Permalink terminado em node de primeiro nível [GET]

+ Parameters
    + id: `enem-e-vestibulares` (string, required) - permalink_contents/{id}

+ Response 200 (application/json; charset=utf-8)
    + Body

                {
                  "data": {
                    "id": "1",
                    "type": "permalinks",
                    "attributes": {
                      "slug": "enem-e-vestibulares",
                      "canonical-uri": null
                    }
                  },
                  "meta": {
                    "entities": [{
                      "id": 2,
                      "name": "Enem e Vestibulares",
                      "slug": "enem-e-vestibulares",
                      "description": null,
                      "image": {
                        "url": null
                      },
                      "video": null,
                      "color-hex": null,
                      "created-by": null,
                      "updated-by": null,
                      "node-type": "education_segment",
                      "suggested-to": null,
                      "pre-requisite": null,
                      "children": [{
                        "name": "Plano de estudos 1",
                        "slug": "plano-de-estudos-1",
                        "image": {
                          "url": null
                        },
                        "color-hex": null,
                        "media": []
                      }, {
                        "name": "Propostas de Correção de Redação",
                        "slug": "propostas-de-correcao-de-redacao",
                        "image": {
                          "url": null
                        },
                        "color-hex": null,
                        "media": []
                      }],
                      "entity-type": "node",
                      "node-modules": [],
                      "media": []
                    }]
                  }
                }

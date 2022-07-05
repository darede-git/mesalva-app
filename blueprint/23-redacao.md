# Group Redação

## Redações [/essay_submissions]
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

### Enviar nova Redação [POST]
O campo `essay` é de uso exclusivo para imagens do tipo .png

+ Request (application/json)
    + Body

                {
                  "permalink_slug": "enem-e-vestibulares/propostas-de-correcao-de-redacao/linguagens-codigos-e-suas-tecnologias/redacao/redr-propostas-de-redacao/propostas-de-redacao-vestibulares/redacao-basica",
                  "correction_style_id": 1,
                  "essay": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP4z8DwHwAFAAH/VscvDQAAAABJRU5ErkJggg==",
                  "correction_type": "redacao-padrao",
                  "draft": {
                    "steps": {
                      "1": {
                        "description": "descrição 1",
                        "info": "info1",
                        "text": "texto 1",
                        "title": "Titulo 1"
                      }
                    }
                  }
                }

    + Headers

                uid:  user@integration.com
                access-token:  kaTuL76JKSqWb9PmwnQYQA
                client:  WEB

+ Response 201 (application/json; charset=utf-8)
    + Body

              {
                "data": {
                  "id": "QCwSla07-rcM5aJ9",
                    "type": "essay-submissions",
                    "attributes": {
                      "active": true,
                      "grades": null,
                      "valuer-uid": null,
                      "feedback": null,
                      "created-at": "2017-01-31T19:09:21.423Z",
                      "leadtime": 10,
                      "updated-at": "2017-02-12T08:44:42.174Z",
                      "correction-type": "redacao-padrao",
                      "uncorrectable-message": null,
                      "appearance": {},
                      "grade-final": null,
                      "updated-by-uid": null,
                      "rating": 0,
                      "draft": {
                        "steps": {
                          "1": {
                            "description": "descrição 1",
                            "info": "info1",
                            "text": "texto 1",
                            "title": "Titulo 1"
                          }
                        }
                      },
                      "draft-feedback": null,
                      "status": "awaiting_correction",
                      "permalink-slug": "enem-e-vestibulares/propostas-de-correcao-de-redacao/linguagens-codigos-e-suas-tecnologias/redacao/redr-propostas-de-redacao/propostas-de-redacao-vestibulares/redacao-basica",
                      "item-name": "Propostas de Redação - Vestibulares",
                      "essay": {
                        "url": "https://cdnqa.mesalva.com/uploads/essay_submission/essay/integration.png"
                      },
                      "corrected-essay": {
                        "url": null
                      }
                    },
                    "relationships": {
                      "user": {
                        "data": {
                          "id": "user@integration.com",
                          "type": "users"
                        }
                      },
                      "correction-style": {
                        "data": {
                          "id": "1",
                          "type": "correction-styles"
                        }
                      }
                    }
                }
              }


## Listagem de Redações [/essay_submissions?status=awaiting_correction&order=asc]
### Listagem de redações com filtro [GET]
Ordernamento pode ser 'asc' ou 'desc', ordenando os resultados pela data de criação.
+ Request (application/json)

    + Headers

                uid:  admin@integration.com
                access-token:  LkoOFd6bnxRqk1xJlsQYHA
                client:  WEB

+ Response 200 (application/json; charset=utf-8)

    + Body

              {
                "data": [{
                  "id": "SNvepY3sULGSVENCnpOCdw",
                  "type": "essay-submissions",
                  "attributes": {                    
                    "active": true,
                    "grades": null,
                    "feedback": null,
                    "created-at": "2017-02-12T08:44:42.174Z",
                    "leadtime": 10,
                    "valuer-uid": null,
                    "updated-at": "2017-02-12T08:44:42.174Z",
                    "correction-type": "redacao-padrao",
                    "uncorrectable-message": null,
                    "grade-final": null,
                    "appearance": {},
                    "updated-by-uid": null,
                    "rating": null,
                    "draft": {
                      "steps": {
                        "1": {
                          "info": "info1",
                          "text": "texto 1",
                          "title": "Titulo 1",
                          "description": "descrição 1"
                        }
                      }
                    },
                    "draft-feedback": null,
                    "status": "awaiting_correction",
                    "essay": {
                      "url": "https://cdnqa.mesalva.com/uploads/essay_submission/essay/integration.png"
                    },
                    "corrected-essay": {
                      "url": null
                    },
                    "permalink-slug": "enem-e-vestibulares/propostas-de-correcao-de-redacao/linguagens-codigos-e-suas-tecnologias/redacao/redr-propostas-de-redacao/propostas-de-redacao-vestibulares/redacao-basica",
                    "item-name": "Propostas de Redação - Vestibulares"
                  },
                  "relationships": {
                    "user": {
                      "data": {
                        "id": "user@integration.com",
                        "type": "users"
                      }
                    },
                    "correction-style": {
                      "data": {
                        "id": "1",
                        "type": "correction-styles"
                      }
                    },
                    "comments": {
                      "data": []
                    },
                    "essay-marks": {
                      "data": []
                    }
                  }
                }, {
                  "id": "2m5BgWubSxGWxwXi",
                  "type": "essay-submissions",
                  "attributes": {
                    "active": true,
                    "grades": {
                      "grade-1": "10",
                      "grade-2": "20",
                      "grade-3": "10",
                      "grade-4": "10",
                      "grade-5": "10"
                    },
                    "feedback": null,
                    "created-at": "2017-02-12T08:44:42.174Z",
                    "leadtime": 10,
                    "valuer-uid": null,
                    "updated-at": "2017-02-12T08:44:42.174Z",
                    "correction-type": "redacao-padrao",
                    "uncorrectable-message": null,
                    "grade-final": 60,
                    "appearance": {
                      "rotation": "90"
                    },
                    "updated-by-uid": null,
                    "rating": null,
                    "draft": {},
                    "draft-feedback": null,
                    "status": "awaiting_correction",
                    "essay": {
                      "url": "https://cdnqa.mesalva.com/uploads/essay_submission/essay/integration.png"
                    },
                    "corrected-essay": {
                      "url": null
                    },
                    "permalink-slug": "enem-e-vestibulares/propostas-de-correcao-de-redacao/linguagens-codigos-e-suas-tecnologias/redacao/redr-propostas-de-redacao/propostas-de-redacao-vestibulares/redacao-basica",
                    "item-name": "Propostas de Redação - Vestibulares"
                  },
                  "relationships": {
                    "user": {
                      "data": {
                        "id": "user@integration.com",
                        "type": "users"
                      }
                    },
                    "correction-style": {
                      "data": {
                        "id": "1",
                        "type": "correction-styles"
                      }
                    },
                    "comments": {
                      "data": [{
                        "id": "wFbquQQmeaniQiygJPQd1g",
                        "type": "comments"
                      }]
                    },
                    "essay-marks": {
                      "data": []
                    }
                  }
                }],
                "included": [{
                  "id": "user@integration.com",
                  "type": "users",
                  "attributes": {
                    "provider": "email",
                    "uid": "user@integration.com",
                    "name": "User Test",
                    "image": {
                      "url": null
                    },
                    "email": "user@integration.com",
                    "birth-date": null,
                    "gender": null,
                    "studies": null,
                    "dreams": null,
                    "premium": true,
                    "origin": null,
                    "active": true,
                    "created-at": "2017-02-12T08:44:42.174Z",
                    "facebook-uid": null,
                    "google-uid": null,
                    "phone-area": null,
                      "phone-number": null,
                      "profile": null
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
                      }, {
                        "id": "1",
                        "type": "correction-styles",
                        "attributes": {
                          "name": "ENEM",
                          "leadtime": 10
                        }
                      }],
                      "links": {
                        "self": "http://127.0.0.1:3001/essay_submissions?order=asc\u0026page%5Bnumber%5D=1\u0026page%5Bsize%5D=20\u0026status=awaiting_correction",
                        "first": "http://127.0.0.1:3001/essay_submissions?order=asc\u0026page%5Bnumber%5D=1\u0026page%5Bsize%5D=20\u0026status=awaiting_correction",
                        "prev": null,
                        "next": null,
                        "last": "http://127.0.0.1:3001/essay_submissions?order=asc\u0026page%5Bnumber%5D=1\u0026page%5Bsize%5D=20\u0026status=awaiting_correction"
                      }
                    }


## Listagem de Redações [/essay_submissions?correction_style_id=1]
### Listagem de redações com filtro [GET]
Valores de filtros diretos possíveis são `correction_style_id` e `correction_type`
Valores de filtros relacionados possíveis são:
```
uid - para filtro por user apenas para admin
status - com os seguintes valores possíveis: pending, awaiting_correction, correcting, corrected, delivered, cancelled, uncorrectable
permalink_slug - para filtro por slug da proposta de redação, identificada pelo permalink
```

+ Request (application/json)

    + Headers

                uid:  admin@integration.com
                access-token:  LkoOFd6bnxRqk1xJlsQYHA
                client:  WEB

+ Response 200 (application/json; charset=utf-8)

    + Body

                {
                  "data": [
                    {
                      "id": "zIP-Kv_I_zt0-9xrldZuww",
                      "type": "essay-submissions",
                      "attributes": {
                        "active": true,
                        "grades": null,
                        "feedback": null,
                        "created-at": "2017-02-12T08:44:42.174Z",
                        "leadtime": 10,
                        "valuer-uid": null,
                        "updated-at": "2017-02-12T08:44:42.174Z",
                        "correction-type": "redacao-padrao",
                        "uncorrectable-message": null,
                        "grade-final": null,
                        "appearance": null,
                        "updated-by-uid": null,
                        "rating": 0,
                        "draft": {
                          "steps": {
                            "1": {
                              "info": "info1",
                              "text": "texto 1",
                              "title": "Titulo 1",
                              "description": "descrição 1"
                            }
                          }
                        },
                        "draft-feedback": null,
                        "status": "awaiting_correction",
                        "essay": {
                          "url": "https://cdnqa.mesalva.com/uploads/essay_submission/essay/integration.png"
                        },
                        "corrected-essay": {
                          "url": null
                        },
                        "permalink-slug": "enem-e-vestibulares/propostas-de-correcao-de-redacao/linguagens-codigos-e-suas-tecnologias/redacao/redr-propostas-de-redacao/propostas-de-redacao-vestibulares/redacao-basica",
                        "item-name": "Propostas de Redação - Vestibulares"
                      },
                      "relationships": {
                        "user": {
                          "data": {
                            "id": "user@integration.com",
                            "type": "users"
                          }
                        },
                        "correction-style": {
                          "data": {
                            "id": "1",
                            "type": "correction-styles"
                          }
                        },
                        "comments": {
                          "data": []
                        },
                        "essay-marks": {
                          "data": []
                        }
                      }
                    },
                    {
                      "id": "2m5BgWubSxGWxwXi",
                      "type": "essay-submissions",
                      "attributes": {
                        "active": true,
                        "grades": {
                          "grade-1": "10",
                          "grade-2": "20",
                          "grade-3": "10",
                          "grade-4": "10",
                          "grade-5": "10"
                        },
                        "feedback": null,
                        "created-at": "2017-02-12T08:44:42.174Z",
                        "leadtime": 10,
                        "valuer-uid": null,
                        "updated-at": "2017-02-12T08:44:42.174Z",
                        "correction-type": "redacao-padrao",
                        "uncorrectable-message": null,
                        "grade-final": 60,
                        "appearance": {
                          "rotation": "90"
                        },
                        "updated-by-uid": null,
                        "rating": 0,
                        "draft": {},
                        "draft-feedback": null,
                        "status": "awaiting_correction",
                        "essay": {
                          "url": "https://cdnqa.mesalva.com/uploads/essay_submission/essay/integration.png"
                        },
                        "corrected-essay": {
                          "url": null
                        },
                        "permalink-slug": "enem-e-vestibulares/propostas-de-correcao-de-redacao/linguagens-codigos-e-suas-tecnologias/redacao/redr-propostas-de-redacao/propostas-de-redacao-vestibulares/redacao-basica",
                        "item-name": "Propostas de Redação - Vestibulares"
                      },
                      "relationships": {
                        "user": {
                          "data": {
                            "id": "user@integration.com",
                            "type": "users"
                          }
                        },
                        "correction-style": {
                          "data": {
                            "id": "1",
                            "type": "correction-styles"
                          }
                        },
                        "comments": {
                          "data": [
                            {
                              "id": "Sk7hALinyeUiTZ4S4DGD8g",
                              "type": "comments"
                            }
                          ]
                        },
                        "essay-marks": {
                          "data": []
                        }
                      }
                    }
                  ],
                  "included": [
                    {
                      "id": "user@integration.com",
                      "type": "users",
                      "attributes": {
                        "provider": "email",
                        "uid": "user@integration.com",
                        "name": "User Test",
                        "image": {
                          "url": null
                        },
                        "email": "user@integration.com",
                        "birth-date": null,
                        "gender": null,
                        "studies": null,
                        "dreams": null,
                        "premium": true,
                        "origin": null,
                        "active": true,
                        "created-at": "2017-02-12T08:44:42.174Z",
                        "facebook-uid": null,
                        "google-uid": null,
                        "phone-area": null,
                        "phone-number": null,
                        "profile": null
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
                    },
                    {
                      "id": "1",
                      "type": "correction-styles",
                      "attributes": {
                        "name": "ENEM",
                        "leadtime": 10
                      }
                    }
                  ],
                  "links": {
                    "self": "http://127.0.0.1:3001/essay_submissions?correction_style_id=1&page%5Bnumber%5D=1&page%5Bsize%5D=20",
                    "first": "http://127.0.0.1:3001/essay_submissions?correction_style_id=1&page%5Bnumber%5D=1&page%5Bsize%5D=20",
                    "prev": null,
                    "next": null,
                    "last": "http://127.0.0.1:3001/essay_submissions?correction_style_id=1&page%5Bnumber%5D=1&page%5Bsize%5D=20"
                  }
                }

## Visualização de Redação [/essay_submissions/{id}]
### Visualização de redação [GET]

+ Parameters
    + id: `2m5BgWubSxGWxwXi` (string, required) - Id da redação

+ Request (application/json)
    + Headers

                uid:  user@integration.com
                access-token:  kaTuL76JKSqWb9PmwnQYQA
                client:  WEB

+ Response 200 (application/json; charset=utf-8)
    + Body

                {
                  "data": {
                    "id": "2m5BgWubSxGWxwXi",
                    "type": "essay-submission",
                    "attributes": {
                      "active": true,
                      "grades": {
                        "grade_1": "10",
                        "grade_2": "20",
                        "grade_3": "10",
                        "grade_4": "10",
                        "grade_5": "10"
                      },
                      "valuer-uid": null,
                      "feedback": null,
                      "created-at": "2017-02-12T08:44:42.174Z",
                      "leadtime": 10,
                      "updated-at": "2017-02-12T08:44:42.174Z",
                      "correction-type": "redacao-padrao",
                      "uncorrectable-message": null,
                      "appearance": {
                        "rotation": "90"
                      },
                      "grade-final": 60,
                      "updated-by-uid": null,
                      "rating": 0,
                      "draft": {},
                      "draft-feedback": null,
                      "status": "awaiting_correction",
                      "essay": {
                        "url": "https://cdnqa.mesalva.com/uploads/essay_submission/essay/integration.png"
                      },
                      "corrected-essay": {
                        "url": null
                      },
                      "permalink-slug": "enem-e-vestibulares/propostas-de-correcao-de-redacao/linguagens-codigos-e-suas-tecnologias/redacao/redr-propostas-de-redacao/propostas-de-redacao-vestibulares/redacao-basica",
                      "item-name": "Propostas de Redação - Vestibulares"                  
                    },
                    "relationships": {
                      "user": {
                        "data": {
                          "id": "user@integration.com",
                          "type": "user"
                        }
                      },
                      "correction-style": {
                        "data": {
                          "id": "1",
                          "type": "correction-style"
                        }
                      },
                      "essay-marks": {
                        "data": []
                      }
                    }
                  },
                  "included": [
                    {
                      "id": "1",
                      "type": "correction-style",
                      "attributes": {
                        "name": "ENEM",
                        "leadtime": 10
                      }
                    },
                    {
                      "id": "user@integration.com",
                      "type": "user",
                      "attributes": {
                        "provider": "email",
                        "name": "User Test",
                        "email": "user@integration.com",
                        "birth-date": null,
                        "gender": null,
                        "studies": null,
                        "dreams": null,
                        "premium": true,
                        "origin": null,
                        "active": true,
                        "created-at": "2017-02-12T08:44:42.174Z",
                        "phone-area": null,
                        "profile": null,
                        "phone-number": null,
                        "facebook-uid": null,
                        "google-uid": null,
                        "image": {
                          "url": null
                        }
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
                  ]
                }


### Atualização de redações [PUT]
###### O campo `corrected_essay` é de uso exclusivo para imagens do tipo .png
###### Os status são: `awaiting_correction, correcting, corrected, delivered, cancelled, uncorrectable`.

+ Parameters
    + id: `2m5BgWubSxGWxwXi` (string, required) - Id da redação

+ Request (application/json)
    + Body

                {
                  "id": "2m5BgWubSxGWxwXi",
                  "status": "correcting"
                }

    + Headers

                uid:  admin@integration.com
                access-token:  LkoOFd6bnxRqk1xJlsQYHA
                client:  WEB

+ Response 200 (application/json; charset=utf-8)
    + Body

              {
                "data": {
                  "id": "2m5BgWubSxGWxwXi",
                  "type": "essay-submission",
                  "attributes": {
                    "active": true,
                    "grades": {
                      "grade_1": "10",
                      "grade_2": "20",
                      "grade_3": "10",
                      "grade_4": "10",
                      "grade_5": "10"
                    },
                    "valuer-uid": "admin@integration.com",
                    "feedback": null,
                    "created-at": "2017-02-12T08:44:42.174Z",
                    "leadtime": 10,
                    "updated-at": "2017-02-12T08:44:42.174Z",
                    "correction-type": "redacao-padrao",
                    "uncorrectable-message": null,
                    "appearance": {
                      "rotation": "90"
                    },
                    "grade-final": 60,
                    "updated-by-uid": null,
                    "rating": 0,
                    "draft": {},
                    "draft-feedback": null,
                    "status": "correcting",
                    "essay": {
                      "url": "https://cdnqa.mesalva.com/uploads/essay_submission/essay/integration.png"
                    },
                    "corrected-essay": {
                      "url": null
                    },
                    "permalink-slug": "enem-e-vestibulares/propostas-de-correcao-de-redacao/linguagens-codigos-e-suas-tecnologias/redacao/redr-propostas-de-redacao/propostas-de-redacao-vestibulares/redacao-basica",
                    "item-name": "Propostas de Redação - Vestibulares"
                  },
                  "relationships": {
                    "user": {
                      "data": {
                        "id": "user@integration.com",
                        "type": "user"
                      }
                    },
                    "correction-style": {
                      "data": {
                        "id": "1",
                        "type": "correction-style"
                      }
                    },
                    "essay-marks": {
                      "data": []
                    }
                  }
                },
                "included": [
                  {
                    "id": "1",
                    "type": "correction-style",
                    "attributes": {
                      "name": "ENEM",
                      "leadtime": 10
                    }
                  },
                  {
                    "id": "user@integration.com",
                    "type": "user",
                    "attributes": {
                      "provider": "email",
                      "name": "Novo nome com atributo",
                      "email": "user@integration.com",
                      "birth-date": "26-02-1994",
                      "gender": "Masculino",
                      "studies": "Complementar",
                      "dreams": "Quero estudar design automotivo para poder desenhar meus próprios carros",
                      "premium": true,
                      "origin": "Indicação de um amigo",
                      "active": true,
                      "created-at": "2017-02-12T08:44:42.174Z",
                      "phone-area": null,
                      "profile": null,
                      "phone-number": null,
                      "facebook-uid": null,
                      "google-uid": null,
                      "image": {
                        "url": "https://cdnqa.mesalva.com/uploads/user/image/integration.jpeg"
                      }
                    },
                    "relationships": {
                      "address": {
                        "data": {
                          "id": "8",
                          "type": "address"
                        }
                      },
                      "academic-info": {
                        "data": {
                          "id": "1",
                          "type": "academic-info"
                        }
                      },
                      "education-level": {
                        "data": {
                          "id": "1",
                          "type": "education-level"
                        }
                      },
                      "objective": {
                        "data": {
                          "id": "1",
                          "type": "objective"
                        }
                      }
                    }
                  }
                ]
              }

## Listagem de Estilos de Correções [/correction_styles]
### Listagem de estilos de correções [GET]
+ Request (application/json)

    + Headers

                uid:  admin@integration.com
                access-token:  LkoOFd6bnxRqk1xJlsQYHA
                client:  WEB

+ Response 200 (application/json; charset=utf-8)

                {
                  "data": [{
                    "id": "1",
                    "type": "correction-styles",
                    "attributes": {
                      "name": "Enem e Vestibulares",
                      "leadtime": 10
                    }
                  }]
                }

## Criação de comentários em redações [/essay_submissions/{essay_submission_id}/comments]
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

### Criar um novo comentário de redação [POST]
+ Parameters
    + id: `2m5BgWubSxGWxwXi` (string, required) - Id da redação

+ Request (application/json)
    + Headers

                uid:  admin@integration.com
                access-token:  LkoOFd6bnxRqk1xJlsQYHA
                client:  WEB
                Content-Type: application/json; charset=utf-8

    + Body

                {
                  "text": "Exatamente!"
                }

+ Response 201 (application/json; charset=utf-8)

                {
                  "data": {
                    "id": "bv68VniTNJsIkxkVANGWIg",
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
                      "commentable": {
                        "data": {
                          "id": "admin@integration.com",
                          "type": "admins"
                        }
                      }
                    }
                  }
                }

## Atualização de comentários em redações [/essay_submissions/{essay_submission_id}/comments/{id}]
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

### Atualização de um comentários [PUT]
+ Parameters
    + id: `Token` (string, required) - Id do comentário
    + essay_submission_id: `2m5BgWubSxGWxwXi` (string, required) - Id da redação

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

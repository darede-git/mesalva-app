# Group Acessos

<!--## Novo Acesso [/accesses]
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


### Visualização de acessos [GET]
Pode se filtrar apenas acessos ativos passando o parametro `valid` com o valor: true

+ Request (application/json)
    + Headers

                uid:  admin@integration.com
                access-token:  LkoOFd6bnxRqk1xJlsQYHA
                client:  WEB

    + Body

                {
                  "user_uid": "user@integration.com"
                }

+ Response 200 (application/json; charset=utf-8)

                {
                  "data": [{
                    "id": "1",
                    "type": "access",
                    "attributes": {
                      "user-uid": "user@integration.com",
                      "starts-at": "2017-02-12T08:44:42.174Z",
                      "expires-at": "2017-02-12T08:44:42.174Z",
                      "remaining-days": null,
                      "active": true,
                      "updated-at": "2017-02-12T08:44:42.174Z",
                      "subscription-active": null,
                      "gift": null,
                      "created-by": null,
                      "in-app-subscription": false
                    },
                    "relationships": {
                      "order": {
                        "data": {
                          "id": "AoXz1Y4kWW8q9WdC",
                          "type": "orders"
                        }
                      },
                      "package": {
                        "data": {
                          "id": "100",
                          "type": "packages"
                        }
                      }
                    }
                  }, {
                    "id": "2",
                    "type": "access",
                    "attributes": {
                      "user-uid": "user@integration.com",
                      "starts-at": "2017-02-12T08:44:42.174Z",
                      "expires-at": "2017-02-12T08:44:42.174Z",
                      "remaining-days": null,
                      "active": true,
                      "updated-at": "2017-02-12T08:44:42.174Z",
                      "subscription-active": true,
                      "gift": false,
                      "created-by": null,
                      "in-app-subscription": false
                    },
                    "relationships": {
                      "order": {
                        "data": {
                          "id": "AoXz1Y4kWW8q9Wd4",
                          "type": "orders"
                        }
                      },
                      "package": {
                        "data": {
                          "id": "101",
                          "type": "packages"
                        }
                      }
                    }
                  }, {
                    "id": "4",
                    "type": "access",
                    "attributes": {
                      "user-uid": "user@integration.com",
                      "starts-at": "2017-02-12T08:44:42.174Z",
                      "expires-at": "2017-02-12T08:44:42.174Z",
                      "remaining-days": null,
                      "active": true,
                      "updated-at": "2017-02-12T08:44:42.174Z",
                      "subscription-active": null,
                      "gift": true,
                      "created-by": "admin@integration.com",
                      "in-app-subscription": null
                    },
                    "relationships": {
                      "order": {
                        "data": null
                      },
                      "package": {
                        "data": {
                          "id": "1",
                          "type": "packages"
                        }
                      }
                    }
                  }, {
                    "id": "5",
                    "type": "access",
                    "attributes": {
                      "user-uid": "user@integration.com",
                      "starts-at": "2017-02-12T08:44:42.174Z",
                      "expires-at": "2017-02-12T08:44:42.174Z",
                      "remaining-days": null,
                      "active": true,
                      "updated-at": "2017-02-12T08:44:42.174Z",
                      "subscription-active": null,
                      "gift": null,
                      "created-by": null,
                      "in-app-subscription": true
                    },
                    "relationships": {
                      "order": {
                        "data": {
                          "id": "xQg1biepM07NxNnp",
                          "type": "orders"
                        }
                      },
                      "package": {
                        "data": {
                          "id": "100",
                          "type": "packages"
                        }
                      }
                    }
                  }, {
                    "id": "6",
                    "type": "access",
                    "attributes": {
                      "user-uid": "user@integration.com",
                      "starts-at": "2017-02-12T08:44:42.174Z",
                      "expires-at": "2017-02-12T08:44:42.174Z",
                      "remaining-days": null,
                      "active": true,
                      "updated-at": "2017-02-12T08:44:42.174Z",
                      "subscription-active": null,
                      "gift": null,
                      "created-by": null,
                      "in-app-subscription": true
                    },
                    "relationships": {
                      "order": {
                        "data": {
                          "id": "rhiqoVg0dbRwYXx2",
                          "type": "orders"
                        }
                      },
                      "package": {
                        "data": {
                          "id": "100",
                          "type": "packages"
                        }
                      }
                    }
                  },
                  {
                    "id": "7",
                    "type": "access",
                    "attributes": {
                      "user-uid": "user@integration.com",
                      "starts-at": "2017-02-12T08:44:42.174Z",
                      "expires-at": "2017-02-12T08:44:42.174Z",
                      "remaining-days": null,
                      "active": true,
                      "updated-at": "2017-02-12T08:44:42.174Z",
                      "subscription-active": null,
                      "gift": null,
                      "created-by": null,
                      "in-app-subscription": false
                    },
                    "relationships": {
                      "order": {
                        "data": {
                          "id": "AoXz1Y4kWW8q9WdB",
                          "type": "orders"
                        }
                      },
                      "package": {
                        "data": {
                          "id": "100",
                          "type": "packages"
                        }
                      }
                    }
                  }],
                  "included": [{
                    "id": "100",
                    "type": "packages",
                    "attributes": {
                      "name": "Enem Semestral",
                      "slug": "enem-semestral",
                      "max-payments": 1,
                      "node-ids": [2, 3],
                      "education-segment-slug": "enem-e-vestibulares",
                      "subscription": false,
                      "description": "Descrição do enem semestral",
                      "sales-platforms": ["web"],
                      "info": ["info 1", "info 2"],
                      "form": "MuV5ud",
                      "position": 0,
                      "active": true,
                      "app-store-product-id": "1",
                      "play-store-product-id": "1"
                    },
                    "relationships": {
                      "prices": {
                        "data": [{
                          "id": "1",
                          "type": "prices"
                        }, {
                          "id": "2",
                          "type": "prices"
                        }]
                      },
                      "features": {
                        "data": [{
                          "id": "1",
                          "type": "features"
                        }]
                      }
                    }
                  }, {
                    "id": "1",
                    "type": "features",
                    "attributes": {
                      "name": "Feature1",
                      "slug": "feature1"
                    }
                  }, {
                    "id": "2380",
                    "type": "packages",
                    "attributes": {
                      "name": "Assinatura",
                      "slug": "assinatura",
                      "max-payments": 1,
                      "node-ids": [3],
                      "education-segment-slug": "enem-e-vestibulares",
                      "subscription": true,
                      "description": "Descrição da assinatura",
                      "sales-platforms": ["web"],
                      "info": ["info 1", "info 2"],
                      "form": "MuV5ud",
                      "position": 0,
                      "active": true,
                      "app-store-product-id": null,
                      "play-store-product-id": null
                    },
                    "relationships": {
                      "prices": {
                        "data": [{
                          "id": "3",
                          "type": "prices"
                        }]
                      },
                      "features": {
                        "data": []
                      }
                    }
                  }, {
                    "id": "1",
                    "type": "packages",
                    "attributes": {
                      "name": "Enem Semestral1",
                      "slug": "enem-semestral1",
                      "max-payments": 1,
                      "node-ids": [3],
                      "education-segment-slug": "enem-e-vestibulares",
                      "subscription": false,
                      "description": "Descrição do pacote semestral",
                      "sales-platforms": ["web"],
                      "info": ["6 meses", "Pacote"],
                      "form": null,
                      "position": 1,
                      "active": true,
                      "app-store-product-id": null,
                      "play-store-product-id": null
                    },
                    "relationships": {
                      "prices": {
                        "data": [{
                          "id": "4",
                          "type": "prices"
                        }]
                      },
                      "features": {
                        "data": []
                      }
                    }
                  }]
                }


### Criação de acessos [POST]

+ Request (application/json)
    + Body

                {
                  "user_uid": "user@integration.com",
                  "package_id": "1",
                  "duration": "5"
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
                    "type": "access",
                    "attributes": {
                      "user-uid": "user@integration.com",
                      "starts-at": "2017-02-12T08:44:42.174Z",
                      "expires-at": "2017-02-12T08:44:42.174Z",
                      "remaining-days": null,
                      "active": true,
                      "updated-at": "2017-02-12T08:44:42.174Z",
                      "subscription-active": null,
                      "gift": true,
                      "created-by": "admin@integration.com",
                      "in-app-subscription": null
                    },
                    "relationships": {
                      "order": {
                        "data": null
                      },
                      "package": {
                        "data": {
                          "id": "1",
                          "type": "packages"
                        }
                      }
                    }
                  }
                }-->
<!--
## Acesso [/accesses/{id}]
### Atualização de acessos [PUT]
+ Parameters
    + id: `1` (number, required) - Id do acesso

### Atualização de acessos [PUT]

+ Request (application/json)

    + Body

                {
                  "active": "false"
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
                    "type": "access",
                    "attributes": {
                      "user-uid": "user@integration.com",
                      "starts-at": "2016-10-24T12:55:37.149Z",
                      "expires-at": "2017-04-24T12:55:37.150Z",
                      "remaining-days": null,
                      "active": false,
                      "updated-at": "2016-10-24T12:55:49.573Z",
                      "subscription-active": null,
                      "in-app-subscription": null
                    },
                    "relationships": {
                      "order": {
                        "data": {
                          "id": "AoXz1Y4kWW8q9WdC",
                          "type": "orders"
                        }
                      },
                      "package": {
                        "data": {
                          "id": "100",
                          "type": "packages"
                        }
                      }
                    }
                  }
                }


+ Request Congelamento de acessos (application/json)

    + Body

                {
                  "freeze": "true"
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
                    "type": "access",
                    "attributes": {
                      "user-uid": "user@integration.com",
                      "starts-at": "2016-10-24T12:57:32.927Z",
                      "expires-at": "2017-04-24T12:57:32.928Z",
                      "remaining-days": 181,
                      "active": false,
                      "updated-at": "2016-10-24T12:57:45.912Z",
                      "subscription-active": null,
                      "in-app-subscription": null
                    },
                    "relationships": {
                      "order": {
                        "data": {
                          "id": "AoXz1Y4kWW8q9WdC",
                          "type": "orders"
                        }
                      },
                      "package": {
                        "data": {
                          "id": "100",
                          "type": "packages"
                        }
                      }
                    }
                  }
                }


+ Request Descongelamento de acessos (application/json)

    + Body

                {
                  "unfreeze": "true"
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
                    "type": "access",
                    "attributes": {
                      "user-uid": "user@integration.com",
                      "starts-at": "2016-12-19T19:49:05.534Z",
                      "expires-at": "2017-06-18T19:49:56.976Z",
                      "remaining-days": 0,
                      "active": true,
                      "updated-at": "2016-12-19T19:49:56.977Z",
                      "subscription-active": null,
                      "in-app-subscription": null
                    },
                    "relationships": {
                      "order": {
                        "data": {
                          "id": "AoXz1Y4kWW8q9WdC",
                          "type": "orders"
                        }
                      },
                      "package": {
                        "data": {
                          "id": "100",
                          "type": "packages"
                        }
                      }
                    }
                  }
                }


## Verificar acesso à permalink [/permalink_accesses/{permalink_slug}]
### Visualização de acesso ao permalink V1 [GET]

+ Parameters
    + permalink_slug: `enem-e-vestibulares` (string, required) - slug permalink

+ Request (application/json)
    + Headers

                uid:  user@integration.com
                access-token:  kaTuL76JKSqWb9PmwnQYQA
                client:  WEB

+ Response 200 (application/json; charset=utf-8)
    + Body


                {
                  "permalink-access": {
                    "permalink-slug": "enem-e-vestibulares/plano-de-estudos-1/matematica-e-suas-tecnologias/matematica/trigonometria/o-que-e-um-triangulo/video-basico-1",
                    "status-code": 200,
                    "children": []
                  }
                }-->


### Visualização de acesso ao permalink V2 [GET]

+ Parameters
    + permalink_slug: `enem-e-vestibulares` (string, required) - slug permalink

+ Request (application/json)
    + Headers

                uid:  user@integration.com
                access-token:  kaTuL76JKSqWb9PmwnQYQA
                client:  WEB
                Api-Version: 2

+ Response 200 (application/json; charset=utf-8)
    + Body


                {
                  "data": {
                    "id": "enem-e-vestibulares",
                    "type": "access",
                    "attributes": {
                      "permalink-slug": "enem-e-vestibulares",
                      "status-code": 200,
                      "children": []
                    }
                  }
                }


+ Request Visualização de acesso ao permalink até mídia (application/json)
    + Parameters
        + permalink_slug: `enem-e-vestibulares/plano-de-estudos-1/matematica-e-suas-tecnologias/matematica/trigonometria/o-que-e-um-triangulo/video-basico-1` (string, required) - slug permalink

    + Headers

                uid:  user@integration.com
                access-token:  kaTuL76JKSqWb9PmwnQYQA
                client:  WEB
                Api-Version: 2


+ Response 200 (application/json; charset=utf-8)
    + Body

                {
                  "data": {
                    "id": "enem-e-vestibulares/plano-de-estudos-1/matematica-e-suas-tecnologias/matematica/trigonometria/o-que-e-um-triangulo/video-basico-1",
                    "type": "access",
                    "attributes": {
                      "permalink-slug": "enem-e-vestibulares/plano-de-estudos-1/matematica-e-suas-tecnologias/matematica/trigonometria/o-que-e-um-triangulo/video-basico-1",
                      "status-code": 200,
                      "children": []
                    }
                  }
                }

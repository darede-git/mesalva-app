# Group Pagamentos

## Pagamentos [/orders]
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


### Criar um pagamento através da Play Store [POST]
+ Request (application/json)
    + Body

                  {
                    "broker_product_id": 1,
                    "broker": "play_store",
                    "installments": 1,
                    "email": "email@teste.com",
                    "name": "Nome no boleto",
                    "cpf": "69430742884",
                    "nationality": "Brasileiro",
                    "expires_at": "25/12/2018",
                    "amount_in_cents": "1000",
                    "currency": "BRL",
                    "broker_data": {
                      "orderId": "GPA.3330-3093-4306-66186",
                      "packageName": "com.mesalva",
                      "productId": "subscription_v1",
                      "purchaseTime": "1_501_531_173_350",
                      "purchaseState": "0",
                      "purchaseToken": "opkbjkfjnkmfikkkdhlbphjo.AO-J1OyC6h7hnJ63EZkxqlwxeX2ksCwpe9lbktqn8XpyWKF49QUEnixCqDuNqTgY9SynQfJkjWWGqeCMSq6-OLBiENr8WgvFeb1sd2qsoz9UlA7bVqWpmfk",
                      "autoRenewing": "false"
                    },
                    "address_attributes": {
                      "street": "Rua Padre Chagas",
                      "street_number": 79,
                      "street_detail": "302",
                      "neighborhood": "Moinhos de Vento",
                      "city": "Porto Alegre",
                      "zip_code": "91920-000",
                      "state": "RS",
                      "country": "Brasil",
                      "area_code": "11",
                      "phone_number": "51888888888"
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
                      "id": "zhgmPIhKE_4YdSKe",
                      "type": "orders",
                      "attributes": {
                        "status": "paid",
                        "price-paid": null,
                        "currency": "BRL",
                        "checkout-method": "play_store",
                        "payment-methods": [],
                        "subscription-id": null,
                        "email": "email@teste.com",
                        "created-at": "2017-02-12T08:44:42.174Z",
                        "discount-in-cents": 0
                      },
                      "relationships": {
                        "package": {
                          "data": {
                            "id": "100",
                            "type": "packages"
                          }
                        },
                        "address": {
                          "data": {
                            "id": "5",
                            "type": "addresses"
                          }
                        }
                      }
                    },
                    "included": [{
                      "id": "100",
                      "type": "packages",
                      "attributes": {
                        "name": "Enem Semestral",
                        "slug": "enem-semestral",
                        "max-payments": 1,
                        "node-ids": [2, 3],
                        "subscription": false,
                        "description": "Descrição do enem semestral",
                        "info": ["info 1", "info 2"],
                        "form": "MuV5ud",
                        "position": 0,
                        "active": true
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
                        }
                      }
                    }]
                  }


### Criar um pagamento através da Apple Store [POST]
+ Request (application/json)
    + Body

                  {
                    "broker_product_id": 1,
                    "broker": "app_store",
                    "installments": 1,
                    "email": "email@teste.com",
                    "name": "Nome no boleto",
                    "cpf": "69430742884",
                    "nationality": "Brasileiro",
                    "expires_at": "25/12/2018",
                    "amount_in_cents": "1000",
                    "currency": "USD",
                    "broker_data": {
                      "expires_date_ms": "1_502_917_863_000",
                      "original_purchase_date_ms": "1_502_917_564_000",
                      "original_transaction_id": "1_000_000_325_070_306",
                      "product_id": "assinatura_me_salva_engenharia",
                      "purchase_date_ms": "1_502_917_563_000",
                      "transaction_id": "1_000_000_325_070_306"
                    },
                    "address_attributes": {
                      "street": "Rua Padre Chagas",
                      "street_number": 79,
                      "street_detail": "302",
                      "neighborhood": "Moinhos de Vento",
                      "city": "Porto Alegre",
                      "zip_code": "91920-000",
                      "state": "RS",
                      "country": "Brasil",
                      "area_code": "11",
                      "phone_number": "51999999999"
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
                      "id": "wmYs45CgqmOlkGR3",
                      "type": "orders",
                      "attributes": {
                        "status": "paid",
                        "price-paid": null,
                        "currency": "USD",
                        "checkout-method": "app_store",
                        "payment-methods": [],
                        "subscription-id": null,
                        "email": "email@teste.com",
                        "created-at": "2017-02-12T08:44:42.174Z",
                        "discount-in-cents": 0
                      },
                      "relationships": {
                        "package": {
                          "data": {
                            "id": "100",
                            "type": "packages"
                          }
                        },
                        "address": {
                          "data": {
                            "id": "6",
                            "type": "addresses"
                          }
                        }
                      }
                    },
                    "included": [{
                      "id": "100",
                      "type": "packages",
                      "attributes": {
                        "name": "Enem Semestral",
                        "slug": "enem-semestral",
                        "max-payments": 1,
                        "node-ids": [2, 3],
                        "subscription": false,
                        "description": "Descrição do enem semestral",
                        "info": ["info 1", "info 2"],
                        "form": "MuV5ud",
                        "position": 0,
                        "active": true
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
                        }
                      }
                    }]
                  }


### Lista de pagamentos do usuário via admin [GET]

+ Request (application/json)

    + Body

                {
                  "user_uid": "user@integration.com"
                }

    + Headers

                uid:  admin@integration.com
                access-token:  LkoOFd6bnxRqk1xJlsQYHA
                client:  WEB

+ Response 200 (application/json; charset=utf-8)
    + Body

                {
                  "data": [{
                    "id": "CoXz1Y4kWW8q9Wdl",
                    "type": "orders",
                    "attributes": {
                      "status": "pending",
                      "price-paid": "0.0",
                      "currency": "BRL",
                      "subscription-id": null,
                      "created-at": "2016-09-02T19:10:48.332Z",
                      "checkout-method": "bank_slip",
                      "discount-in-cents": 0
                    },
                    "relationships": {
                      "package": {
                        "data": {
                          "id": "1",
                          "type": "packages"
                        }
                      },
                      "address": {
                        "data": {
                          "id": "1",
                          "type": "addresses"
                        }
                      }
                    }
                  }],
                  "included": [{
                    "id": "1",
                    "type": "packages",
                    "attributes": {
                      "name": "Enem Semestral1",
                      "slug": "enem-semestral1",
                      "max-payments": 1,
                      "node-ids": [3]
                    },
                    "relationships": {
                      "prices": {
                        "data": [{
                          "id": "1",
                          "type": "prices"
                        }]
                      }
                    }
                  }]
                }


### Lista de pagamentos do usuário via user [GET]

+ Request (application/json)
    + Headers

                uid:  user@integration.com
                access-token:  kaTuL76JKSqWb9PmwnQYQA
                client:  WEB

+ Response 200 (application/json; charset=utf-8)
    + Body

                {
                  "data": [{
                    "id": "OT7N8hQirAEaji9n-dD7Gg",
                    "type": "orders",
                    "attributes": {
                      "status": "paid",
                      "price-paid": "10.0",
                      "checkout-method": "app_store",
                      "payment-methods": [{
                        "method": "card",
                        "state": "pending",
                        "amount-in-cents": 1000
                      }],
                      "subscription-id": null,
                      "email": "email@teste.com",
                      "created-at": "2017-02-12T08:44:42.174Z",
                      "discount-in-cents": 0,
                      "currency": "USD",
                      "payments-errors": [null],
                      "refundable": false
                    },
                    "relationships": {
                      "package": {
                        "data": {
                          "id": "100",
                          "type": "packages"
                        }
                      },
                      "address": {
                        "data": {
                          "id": "7",
                          "type": "addresses"
                        }
                      }
                    }
                  }, {
                    "id": "HjxIOpWW_KAX5I0VahSs3w",
                    "type": "orders",
                    "attributes": {
                      "status": "paid",
                      "price-paid": "10.0",
                      "checkout-method": "play_store",
                      "payment-methods": [{
                        "method": "card",
                        "state": "pending",
                        "amount-in-cents": 1000
                      }],
                      "subscription-id": null,
                      "email": "email@teste.com",
                      "created-at": "2017-02-12T08:44:42.174Z",
                      "discount-in-cents": 0,
                      "currency": "BRL",
                      "payments-errors": [null],
                      "refundable": true
                    },
                    "relationships": {
                      "package": {
                        "data": {
                          "id": "100",
                          "type": "packages"
                        }
                      },
                      "address": {
                        "data": {
                          "id": "6",
                          "type": "addresses"
                        }
                      }
                    }
                  }, {
                    "id": "WKijnFGFhOAu8zm2TUv7Qw",
                    "type": "orders",
                    "attributes": {
                      "status": "pending",
                      "price-paid": "10.0",
                      "checkout-method": "bank_slip",
                      "payment-methods": [{
                        "method": "bank_slip",
                        "state": "pending",
                        "amount-in-cents": 1000
                      }],
                      "subscription-id": null,
                      "email": "email@teste.com",
                      "created-at": "2017-02-12T08:44:42.174Z",
                      "discount-in-cents": 0,
                      "currency": "BRL",
                      "payments-errors": [null],
                      "refundable": false
                    },
                    "relationships": {
                      "package": {
                        "data": {
                          "id": "1",
                          "type": "packages"
                        }
                      },
                      "address": {
                        "data": {
                          "id": "5",
                          "type": "addresses"
                        }
                      }
                    }
                  }, {
                    "id": "AoXz1Y4kWW8q9WdC",
                    "type": "orders",
                    "attributes": {
                      "status": "paid",
                      "price-paid": "10.0",
                      "checkout-method": "credit_card",
                      "payment-methods": [{
                        "method": "card",
                        "state": "captured",
                        "amount-in-cents": 1000
                      }],
                      "subscription-id": null,
                      "email": "email@teste.com",
                      "created-at": "2017-02-12T08:44:42.174Z",
                      "discount-in-cents": 0,
                      "currency": "BRL",
                      "payments-errors": [null],
                      "refundable": true
                    },
                    "relationships": {
                      "package": {
                        "data": {
                          "id": "100",
                          "type": "packages"
                        }
                      },
                      "address": {
                        "data": {
                          "id": "4",
                          "type": "addresses"
                        }
                      }
                    }
                  }, {
                    "id": "AoXz1Y4kWW8q9Wd4",
                    "type": "orders",
                    "attributes": {
                      "status": "paid",
                      "price-paid": null,
                      "checkout-method": "credit_card",
                      "payment-methods": [],
                      "subscription-id": "BoYz1Z4kBB8q9WdA",
                      "email": "email@teste.com",
                      "created-at": "2017-02-12T08:44:42.174Z",
                      "discount-in-cents": 0,
                      "currency": "BRL",
                      "payments-errors": [],
                      "refundable": true
                    },
                    "relationships": {
                      "package": {
                        "data": {
                          "id": "2380",
                          "type": "packages"
                        }
                      },
                      "address": {
                        "data": {
                          "id": "3",
                          "type": "addresses"
                        }
                      }
                    }
                  }, {
                    "id": "AoXz1Y4kWW8q9Wd1",
                    "type": "orders",
                    "attributes": {
                      "status": "pending",
                      "price-paid": "10.0",
                      "checkout-method": "bank_slip",
                      "payment-methods": [],
                      "subscription-id": null,
                      "email": "email@teste.com",
                      "created-at": "2017-02-12T08:44:42.174Z",
                      "discount-in-cents": 0,
                      "currency": "BRL",
                      "payments-errors": [],
                      "refundable": false
                    },
                    "relationships": {
                      "package": {
                        "data": {
                          "id": "100",
                          "type": "packages"
                        }
                      },
                      "address": {
                        "data": {
                          "id": "2",
                          "type": "addresses"
                        }
                      }
                    }
                  }, {
                    "id": "AoXz1Y4kWW8q9WdB",
                    "type": "orders",
                    "attributes": {
                      "status": "pending",
                      "price-paid": "10.0",
                      "checkout-method": "bank_slip",
                      "payment-methods": [],
                      "subscription-id": null,
                      "email": "email@teste.com",
                      "created-at": "2017-02-12T08:44:42.174Z",
                      "discount-in-cents": 0,
                      "currency": "BRL",
                      "payments-errors": [],
                      "refundable": false
                    },
                    "relationships": {
                      "package": {
                        "data": {
                          "id": "100",
                          "type": "packages"
                        }
                      },
                      "address": {
                        "data": {
                          "id": "1",
                          "type": "addresses"
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
                      }
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
                      }
                    }
                  }]
                }


## Pagamento [/orders/{id}]
### Busca order via admin [GET]

+ Parameters
    + id: `AoXz1Y4kWW8q9WdB` (string, required) - Id do pagamento

+ Request (application/json)
    + Body

                {
                  "id": "AoXz1Y4kWW8q9WdB"
                }

    + Headers

                uid:  admin@integration.com
                access-token:  LkoOFd6bnxRqk1xJlsQYHA
                client:  WEB

+ Response 200 (application/json; charset=utf-8)
    + Body

                {
                  "data": {
                    "id": "AoXz1Y4kWW8q9WdB",
                    "type": "orders",
                    "attributes": {
                      "status": "pending",
                      "price-paid": "10.0",
                      "checkout-method": "bank_slip",
                      "payment-methods": [],
                      "subscription-id": null,
                      "email": "email@teste.com",
                      "created-at": "2017-02-12T08:44:42.174Z",
                      "discount-in-cents": 0,
                      "currency": "BRL",
                      "payments-errors": [],
                      "refundable": false
                    },
                    "relationships": {
                      "package": {
                        "data": {
                          "id": "100",
                          "type": "packages"
                        }
                      },
                      "address": {
                        "data": {
                          "id": "1",
                          "type": "addresses"
                        }
                      }
                    }
                  },
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
                      }
                    }
                  }],
                  "meta": {
                    "pdf": "https://faturas.iugu.com/bb52a542-183c-44c9-9d21-75dd453f6288-a9c1.pdf"
                  }
                }


### Busca order via user [GET]

+ Parameters
    + id: `AoXz1Y4kWW8q9WdB` (string, required) - Id do pagamento

+ Request (application/json)
    + Body

                {
                  "id": "AoXz1Y4kWW8q9WdB"
                }

    + Headers

                uid:  user@integration.com
                access-token:  kaTuL76JKSqWb9PmwnQYQA
                client:  WEB

+ Response 200 (application/json; charset=utf-8)
    + Body

                {
                  "data": {
                    "id": "AoXz1Y4kWW8q9WdB",
                    "type": "orders",
                    "attributes": {
                      "status": "pending",
                      "price-paid": "10.00",
                      "currency": "BRL",
                      "subscription-id": null,
                      "created-at": "2016-09-02T19:10:48.332Z",
                      "checkout-method": "bank_slip",
                      "discount-in-cents": 0
                    },
                    "relationships": {
                      "package": {
                        "data": {
                          "id": "100",
                          "type": "packages"
                        }
                      },
                      "address": {
                        "data": {
                          "id": "1",
                          "type": "addresses"
                        }
                      }
                    }
                  },
                  "included": [{
                    "id": "1",
                    "type": "packages",
                    "attributes": {
                      "name": "Enem Semestral",
                      "slug": "enem-semestral",
                      "max-payments": 1,
                      "node-ids": [3]
                    },
                    "relationships": {
                      "prices": {
                        "data": [{
                          "id": "1",
                          "type": "prices"
                        }]
                      }
                    }
                  }],
                  "meta": {
                    "pdf": "https://api.pagar.me/1/boletos/live_cj6w94kaa0gyjlg3dci90yvob"
                  }
                }

### Atualização de Orders [PUT]
+ Parameters
    + id: `AoXz1Y4kWW8q9WdB` (string, required) - Id do pagamento

+ Request (application/json)
    + Body

                {
                  "cpf": "12345678912",
                  "email": "email@order.com"
                }

    + Headers

                uid:  user@integration.com
                access-token:  kaTuL76JKSqWb9PmwnQYQA
                client:  WEB

+ Response 200 (application/json; charset=utf-8)
    + Body

                {
                  "data": {
                    "id": "AoXz1Y4kWW8q9WdB",
                    "type": "orders",
                    "attributes": {
                      "status": "pending",
                      "price-paid": "10.0",
                      "checkout-method": "bank_slip",
                      "payment-methods": [],
                      "subscription-id": null,
                      "email": "email@order.com",
                      "created-at": "2017-02-12T08:44:42.174Z",
                      "discount-in-cents": 0,
                      "currency": "BRL",
                      "payments-errors": []
                    },
                    "relationships": {
                      "package": {
                        "data": {
                          "id": "100",
                          "type": "packages"
                        }
                      },
                      "address": {
                        "data": {
                          "id": "1",
                          "type": "addresses"
                        }
                      }
                    }
                  }
                }

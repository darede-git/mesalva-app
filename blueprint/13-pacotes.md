# Group Pacotes

## Criação e listagem de Pacotes [/packages]
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


### Criação de Pacotes [POST]

+ Request (application/json)
    + Body

                {
                  "name": "Enem Semestral1",
                  "expires_at": "",
                  "duration": 6,
                  "active": "true",
                  "subscription": false,
                  "description": "Descrição do pacote semestral",
                  "listed":true,
                  "essay_credits":10,
                  "private_class_credits": 0,
                  "unlimited_essay_credits":false,
                  "education_segment_slug": "enem-e-vestibulares",
                  "sales_platforms": ["web"],
                  "info": ["6 meses", "Pacote"],
                  "label": ["extensivo-introducao", "extensivo-medicina"],
                  "position": 1,
                  "max_payments": 1,
                  "node_ids": [3],
                  "active": true,
                  "prices_attributes":
                    [
                      {
                        "price_type": "bank_slip",
                        "value": 10.00
                      }
                    ]
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
                      "label": ["extensivo-introducao", "extensivo-medicina"],
                      "form": null,
                      "position": 1,
                      "active": true
                    },
                    "relationships": {
                      "prices": {
                        "data": [{
                          "id": "4",
                          "type": "prices"
                        }]
                      }
                    }
                  },
                  "included": [{
                    "id": "4",
                    "type": "prices",
                    "attributes": {
                      "value": "10.0",
                      "price-type": "bank_slip",
                      "currency": "BRL"
                    }
                  }]
                }


## Pacotes filtrados por segmento de ensino [/packages?education_segment_slug={education_segment_slug}]
### Lista de pacotes filtrados por segmento de ensino [GET]
+ Request (application/json)
    + Headers
                uid:  admin@integration.com
                access-token:  LkoOFd6bnxRqk1xJlsQYHA
                client:  WEB

    + Parameters
        + education_segment_slug: `enem-e-vestibulares` (string, required) - Slug do education segment

+ Response 200 (application/json; charset=utf-8)
    + Body

                {
                  "data": [{
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
                      "label": [],
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
                  }],
                  "included": [{
                    "id": "1",
                    "type": "prices",
                    "attributes": {
                      "value": "10.0",
                      "price-type": "bank_slip",
                      "currency": "BRL"
                    }
                  }, {
                    "id": "2",
                    "type": "prices",
                    "attributes": {
                      "value": "10.0",
                      "price-type": "play_store",
                      "currency": "BRL"
                    }
                  }]
                }


## Pacotes filtrados por plataforma [/packages?platform={platform}]
### Lista de pacotes filtrados por plataforma [GET]
+ Request (application/json)
    + Headers
                uid:  admin@integration.com
                access-token:  LkoOFd6bnxRqk1xJlsQYHA
                client:  WEB

    + Parameters
        + platform: `web` (string, required) - Plataforma

+ Response 200 (application/json; charset=utf-8)
    + Body

                {
                  "data": [{
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
                      "label": [],
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
                  }],
                  "included": [{
                    "id": "1",
                    "type": "prices",
                    "attributes": {
                      "value": "10.0",
                      "price-type": "bank_slip",
                      "currency": "BRL"
                    }
                  }, {
                    "id": "2",
                    "type": "prices",
                    "attributes": {
                      "value": "10.0",
                      "price-type": "play_store",
                      "currency": "BRL"
                    }
                  }]
                }


## Pacotes filtrados por segmento de ensino e plataforma [/packages?education_segment_slug={education_segment_slug}&platform={platform}]
### Lista de pacotes filtrados por segmento de ensino [GET]
+ Request (application/json)
    + Parameters
        + education_segment_slug: `enem-e-vestibulares` (string, required) - Slug do education segment
        + platform: `web` (string, required) - Plataforma

+ Response 200 (application/json; charset=utf-8)
    + Body

                {
                  "data": [{
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
                      "label": [],
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
                  }],
                  "included": [{
                    "id": "1",
                    "type": "prices",
                    "attributes": {
                      "value": "10.0",
                      "price-type": "bank_slip",
                      "currency": "BRL"
                    }
                  }, {
                    "id": "2",
                    "type": "prices",
                    "attributes": {
                      "value": "10.0",
                      "price-type": "play_store",
                      "currency": "BRL"
                    }
                  }]
                }

## Busca e atualização de Pacotes [/packages/{slug}]
### Busca de pacotes [GET]

+ Request (application/json)
    + Headers
                  uid:  user@integration.com
                  access-token:  kaTuL76JKSqWb9PmwnQYQA
                  client:  WEB

    + Parameters
        + slug: `enem-semestral` (string, required) - Slug do Pacote

+ Response 200 (application/json; charset=utf-8)
    + Body

                {
                  "data": {
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
                      "info": [],
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
                  },
                  "included": [{
                    "id": "1",
                    "type": "prices",
                    "attributes": {
                      "value": "10.0",
                      "price-type": "bank_slip",
                      "currency": "BRL"
                    }
                  }, {
                    "id": "2",
                    "type": "prices",
                    "attributes": {
                      "value": "10.0",
                      "price-type": "play_store",
                      "currency": "BRL"
                    }
                  }]
                }


### Atualização de Pacotes [PUT]

+ Request (application/json)
    + Parameters
        + slug: `enem-semestral` (string, required) - Slug do Pacote

    + Body

                {
                  "name": "Mensal ENEM"
                }
    + Headers

                uid:  admin@integration.com
                access-token:  LkoOFd6bnxRqk1xJlsQYHA
                client:  WEB

+ Response 200 (application/json; charset=utf-8)
    + Body

                {
                  "data": {
                    "id": "100",
                    "type": "packages",
                    "attributes": {
                      "name": "Mensal ENEM",
                      "slug": "enem-semestral",
                      "max-payments": 1,
                      "node-ids": [2, 3],
                      "education-segment-slug": "enem-e-vestibulares",
                      "subscription": false,
                      "description": "Descrição do enem semestral",
                      "sales-platforms": ["web"],
                      "info": ["info 1", "info 2"],
                      "info": [],
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
                  },
                  "included": [{
                    "id": "1",
                    "type": "prices",
                    "attributes": {
                      "value": "10.0",
                      "price-type": "bank_slip"
                    }
                  }, {
                    "id": "2",
                    "type": "prices",
                    "attributes": {
                      "value": "10.0",
                      "price-type": "play_store"
                    }
                  }]
                }

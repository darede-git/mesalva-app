# Group Voucher

## Campanha de Voucher [/campaign/voucher]
### Métodos HTTP disponíveis [OPTIONS]

+ Request

    + Headers

                Origin:  http://www.mesalva.com
                Access-Control-Request-Method:  POST

+ Response 200 (text/plain)

    + Headers

                Access-Control-Allow-Origin: http://mesalva.com
                Access-Control-Allow-Methods: HEAD, OPTIONS, POST
                Access-Control-Expose-Headers: access-token, expiry, token-type, uid, client, x-date
                Access-Control-Max-Age: 1728000
                Connection: close
                Transfer-Encoding: chunked


### Cria Acesso do Cupom [POST]

+ Request (application/json)
    + Headers

                uid:  user@integration.com
                access-token:  kaTuL76JKSqWb9PmwnQYQA
                token-type:  Bearer
                client:  WEB

    + Body

                {
                  "token": "LF12345678"
                }

+ Response 201 (application/json; charset=utf-8)
    + Body

                {
                  "data": {
                    "id": "7",
                    "type": "accesses",
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
                  },
                  "included": [
                  {
                    "id": "100",
                    "type": "packages",
                    "attributes": {
                      "name": "Enem Semestral",
                      "slug": "enem-semestral",
                      "max-payments": 1,
                      "node-ids": [
                        2,
                        3
                      ],
                      "education-segment-slug": "enem-e-vestibulares",
                      "subscription": false,
                      "description": "Descrição do enem semestral",
                      "sales-platforms": [
                        "web"
                      ],
                      "info": [
                        "info 1",
                        "info 2"
                      ],
                      "form": "MuV5ud",
                      "position": 0,
                      "active": true,
                      "app-store-product-id": "1",
                      "play-store-product-id": "1"
                    },
                    "relationships": {
                      "prices": {
                        "data": [
                          {
                            "id": "1",
                            "type": "prices"
                          },
                          {
                            "id": "2",
                            "type": "prices"
                          }
                        ]
                      }
                    }
                  }
                ],
                "meta": {
                  "created-by": "user@logout.com"
                }
              }

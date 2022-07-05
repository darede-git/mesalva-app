<!-- # Group Checkout

## Checkout [/checkouts]
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


### Criação de um pagamento em boleto [POST]
##### Se não houver desconto não preencher o campo discount_id.
##### Utilizar 'payment-methods' para expressar os metodos de pagamentos. Para realizar uma cobranca com cartao de credito inserir o campo 'token' => 'PAGARME_CARD_ID'
##### Para utilizar mais de um metodo de pagamento utilizar um array em payment-methods.

+ Request (application/json)
    + Body

                  {
                    "package_id": 1,
                    "email": "email@teste.com",
                    "name": "Tchuchucao",
                    "cpf": "69430742884",
                    "nationality": "Brasileiro",
                    "currency": "BRL",
                    "phone_area": "11",
                    "phone_number": "979911992",
                    "payment_methods": {
                      "method": "bank_slip",
                      "amount_in_cents": "1000",
                      "installments": "1"
                    },
                    "address_attributes": {
                      "street": "Rua Padre Chagas",
                      "street_number": 79,
                      "street_detail": "302",
                      "neighborhood": "Moinhos de Vento",
                      "city": "Porto Alegre",
                      "zip_code": "91920-000",
                      "state": "RS",
                      "country": "Brasil"
                    }
                  }

    + Headers

                  uid:  user@integration.com
                  access-token:  kaTuL76JKSqWb9PmwnQYQA
                  client:  WEB
                  location: -30.0246698, -51.2057501
                  platform: mobile
                  device: iPhone 6S
                  browser: 'app (4.0.2)
                  utm-source: enem
                  utm-medium: 320banner
                  utm-term: matematica
                  utm-content: textlink
                  utm-campaign: mkt

+ Response 201 (application/json; charset=utf-8)
    + Body

                  {
                    "data": {
                      "id": "gCAtEpYTrv49qlSj",
                      "type": "orders",
                      "attributes": {
                        "status": "pending",
                        "price-paid": null,
                        "subscription-id": null,
                        "created-at": "2016-09-02T14:47:10.426Z",
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
                            "id": "7",
                            "type": "addresses"
                          }
                        }
                      }
                    },
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
                    }, {
                      "id": "7",
                      "type": "addresses",
                      "attributes": {
                        "street": "Rua Padre Chagas",
                        "street-number": 79,
                        "street-detail": "302",
                        "neighborhood": "Moinhos de Vento",
                        "city": "Porto Alegre",
                        "zip-code": "91920-000",
                        "state": "RS",
                        "country": "Brasil",
                        "area-code": "11",
                        "phone-number": "979911992"
                      }
                    }],
                    "meta": {
                      "pdf": "https://pagar.me"
                    }
                  } -->

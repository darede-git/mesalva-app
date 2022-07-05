# Group Segmentos de ensino

## Segmentos de ensino [/education_segments]
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


### Lista de segmentos de ensino [GET]

+ Response 200 (application/json; charset=utf-8)
    + Body

                {
                  "data": [{
                    "id": "2",
                    "type": "nodes",
                    "attributes": {
                      "slug": "enem-e-vestibulares",
                      "name": "Enem e Vestibulares",
                      "image": {
                        "url": null
                      }
                    }
                  }]
                }


# Group Matérias de um segmentos de ensino

## Segmentos de ensino [/education_segments/{education_segment_slug}/area_subjects]
### Métodos HTTP disponíveis [OPTIONS]


+ Parameters
    + education_segment_slug: `engenharia` (string, required)

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


### Lista de matérias de um segmentos de ensino [GET]

+ Response 200 (application/json; charset=utf-8)
    + Body

                {
                  "data": [{
                    "id": "12",
                    "type": "nodes",
                    "attributes": {
                      "slug": "matematica",
                      "name": "Matemática",
                      "image": {
                        "url": null
                      }
                    }
                  }]
                }

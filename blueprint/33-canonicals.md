# Group Canonicals

## Canonicals [/permalink_canonical]
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

## Canonicals [/permalink_canonical/{slug}]
### Atualização de canonical_uri em Permalink [PUT]

+ Parameters
    + slug: `enem-e-vestibulares/plano-de-estudos-1/matematica-e-suas-tecnologias/matematica` (string, required) - Slug do permalink


+ Request (application/json)
    + Headers

                client: WEB
                uid:  admin@integration.com
                access-token:  LkoOFd6bnxRqk1xJlsQYHA

    + Body

                {
                  "canonical_uri": "enem-e-vestibulares/plano-de-estudos-1/matematica-e-suas-tecnologias/matematica/trigonometria/o-que-e-um-triangulo/video-basico-1"
                }

+ Response 200 (application/json; charset=utf-8)
    + Body

                {
                  "data": {
                    "id": "1",
                    "type": "permalinks",
                    "attributes": {
                      "slug": "enem-e-vestibulares",
                      "canonical-uri": "enem-e-vestibulares/introducao-ao-enem-2018/matematica-e-suas-tecnologias/introducao-a-matematica/bvin-bem-vindo-a-introducao"
                    }
                  }
                }

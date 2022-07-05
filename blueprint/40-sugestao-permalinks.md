# Group Sugestões de permalinks

## Sugestão de Permalinks [/permalink_suggestions]
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


## Sugestões de permalinks através do permalink slug [/permalink_suggestions/{slug}]
### Lista de sugestões filtrados por permalink slug [GET]

+ Request (application/json)
    + Headers
                  uid:  user@integration.com
                  access-token:  kaTuL76JKSqWb9PmwnQYQA
                  client:  WEB

    + Parameters
        + slug: `enem-e-vestibulares/banco-de-provas/enem/provas-do-enem-2017/matematica-e-suas-tecnologias/137matematicaenem-2017` (string, required) - Slug do Permalink

+ Response 200 (application/json; charset=utf-8)
    + Body

                {
                  "data": [{
                    "id": "1",
                    "type": "permalink-suggestions",
                    "attributes": {
                      "slug": "enem-e-vestibulares/banco-de-provas/enem/provas-do-enem-2017/matematica-e-suas-tecnologias/137matematicaenem-2017",
                      "suggestion-slug": "enem-e-vestibulares/materias/matematica-e-suas-tecnologias/matematica/completo/funcoes-ii-exponenciais-e-logaritmos/inxp-inequacoes-logaritmicas-e-exponenciais",
                      "suggestion-name": "INXP - Inequações Logaritmicas e Exponenciais"
                    }
                  }]
                }

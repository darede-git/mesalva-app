# Group Notas Sisu

## Notas Sisu [/sisu/institutes]
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

## Universidades Sisu filtrados [/sisu/institutes{?course,state,modality}]
### Lista das universidades com as notas Sisu [GET]

+ Request (application/json)
    + Headers

                uid:  user@integration.com
                access-token:  kaTuL76JKSqWb9PmwnQYQA
                token-type:  Bearer
                client:  WEB

    + Parameters
        + course: `101` (integer, required) - id da alternative do curso
        + state: `102` (integer, required) - id da alternative do estado
        + modality: `103` (integer, required) - id da alternative da modalidade

+ Response 200 (application/json; charset=utf-8)
    + Body

                {
                  "data": [{
                    "id": "1",
                    "type": "sisu-institutes",
                    "attributes": {
                      "ies": "CENTRO FEDERAL DE EDUCAÇÃO TECNOLÓGICA CELSO SUCKOW DA FONSECA",
                      "initials": "CEFET/RJ",
                      "shift": "Noturno",
                      "passing-score": "674,24",
                      "year": "2017",
                      "semester": "1"
                    }
                  }]
                }


## Contadores Sisu filtrados [/sisu/counters{?course,state,modality}]
### Lista com os contadores das universidades do Sisu [GET]

+ Request (application/json)
    + Headers

                Origin:  https://www.mesalva.com
                Access-Control-Request-Method:  GET


    + Parameters
        + course: `101` (string, required) - Curso
        + state: `102` (string, required) - Estado
        + modality: `103` (string, required) - Modalidade

+ Response 200 (application/json; charset=utf-8)
    + Body

                {
                  "data": [],
                  "meta": {
                    "institute-count":1,
                    "max-passing-score": 674.0,
                    "min-passing-score": 674.0
                  }
                }

# Group Historico Escolar

## Historico Escolar [/scholar_records]
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


### Cria um historico escolar [POST]
##### O campo "college_id" serve para instituição e "major_id" para o curso, "school" para colegio. Ao preencher "college_id" é obrigatório preencher "major_id"


+ Request (application/json)
    + Headers

                uid:  user@integration.com
                access-token:  kaTuL76JKSqWb9PmwnQYQA
                token-type:  Bearer
                client:  WEB

    + Body

                {
                  "education_level": "Ensino Médio",
                  "level_concluded": false,
                  "study_phase": 3,
                  "school_id": 1,
                  "college_id": null,
                  "major_id": null
                }

+ Response 201 (application/json; charset=utf-8)
    + Body

                {
                  "data": {
                    "id": "1",
                    "type": "scholar-records",
                    "attributes": {
                      "education-level": "Ensino Médio",
                      "level-concluded": false,
                      "study-phase": 3
                    },
                    "relationships": {
                      "user": {
                        "data": {
                          "id": "user@integration.com",
                          "type": "users"
                        }
                      },
                      "major": {
                        "data": null
                      },
                      "college": {
                        "data": null
                      },
                      "school": {
                        "data": {
                          "id": "1",
                          "type": "schools"
                        }
                      }
                    }
                  }
                }


### Lista os historicos escolares ativo [GET]

+ Request (application/json)
    + Headers

                uid:  user@integration.com
                access-token:  kaTuL76JKSqWb9PmwnQYQA
                token-type:  Bearer
                client:  WEB

+ Response 200 (application/json; charset=utf-8)
    + Body

                {
                  "data": [{
                    "id": "1",
                    "type": "scholar-records",
                    "attributes": {
                      "education-level": "Ensino Médio",
                      "level-concluded": false,
                      "study-phase": 3
                    },
                    "relationships": {
                      "user": {
                        "data": {
                          "id": "user@integration.com",
                          "type": "users"
                        }
                      },
                      "major": {
                        "data": null
                      },
                      "college": {
                        "data": null
                      },
                      "school": {
                        "data": {
                          "id": "1",
                          "type": "schools"
                        }
                      }
                    }
                  }]
                }

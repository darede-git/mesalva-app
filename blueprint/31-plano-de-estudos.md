# Planos de estudo

## Plano de estudo [/user/study_plans{?page}]
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


### Lista o plano de estudo atual do usuário [GET]

+ Parameters
    + page: (integer, optional) - Paginação

+ Request (application/json; charset=utf-8)
    + Headers

                uid:  user@integration.com
                access-token:  kaTuL76JKSqWb9PmwnQYQA
                token-type:  Bearer
                client:  WEB

+ Response 200 (application/json; charset=utf-8)
    + Headers

                x-frame-options: SAMEORIGIN
                x-xss-protection: 1; mode=block
                x-content-type-options: nosniff
                x-download-options: noopen
                x-permitted-cross-domain-policies: none
                referrer-policy: strict-origin-when-cross-origin
                content-type: application/json; charset=utf-8
                page: 0
                links: {"self"=>"http://127.0.0.1:3001/user/study_plans", "first"=>"http://127.0.0.1:3001/user/study_plans?page=1", "last"=>"http://127.0.0.1:3001/user/study_plans?page=1"}
                cache-control: no-cache
                x-request-id: d14366fa-1f5a-41ee-8265-cc0491dedb25
                x-runtime: 0.203211
                vary: Origin
                connection: close
                transfer-encoding: chunked

    + Body

                {
                  "data": {
                    "id": "1",
                    "type": "study-plan",
                    "attributes": {
                      "id": 1,
                      "shifts": [
                        {
                          "0": "mid"
                        }
                      ],
                      "start-date": "2017-02-12T08:44:42.174Z",
                      "end-date": "2017-02-12T08:44:42.174Z",
                      "available-time": 12
                    },
                    "relationships": {
                      "user": {
                        "data": {
                          "id": "1",
                          "type": "user"
                        }
                      },
                      "study-plan-node-modules": {
                        "data": [
                          {
                            "id": "1",
                            "type": "study-plan-node-module"
                          }
                        ]
                      }
                    }
                  },
                  "meta": {
                    "modules-count": 1,
                    "offset": 0,
                    "limit": 7,
                    "completed-modules-count": 0,
                    "current-week-completed-modules-count": 0
                  },
                  "included": [
                    {
                      "id": "1",
                      "type": "study-plan-node-module",
                      "attributes": {
                        "node-module": "Trigonometria",
                        "subject": {
                          "name": "Materias",
                          "color-hex": "ED4343"
                        },
                        "permalink": "enem-e-vestibulares/plano-de-estudos-1/matematica-e-suas-tecnologias/materias/trigonometria",
                        "position": 1,
                        "completed": false,
                        "already-known": false
                      }
                    }
                  ]
                }


### Criação de plano de estudos [POST]

+ Request (application/json)
    + Headers

                uid:  user@integration.com
                access-token:  kaTuL76JKSqWb9PmwnQYQA
                token-type:  Bearer
                client:  WEB

    + Body

                {
                  "subject_ids": [994],
                  "shifts": [{ "0": "morning" }, { "0": "mid" }],
                  "end_date": "2019-11-12T08:44:42.174Z",
                  "keep_completed_modules": "true"
                }

+ Response 204



## Plano de estudo [/user/study_plans/{id}]
### Atualização de um plano de estudo [PUT]

+ Parameters
    + id: `1` (number, required) - Id do plano

+ Request (application/json)

    + Attributes

        + ative: Definição do plano de estudos estar ativo ou não.

    + Body

                {
                  "active": "false"
                }

    + Headers

                uid:  user@integration.com
                access-token:  kaTuL76JKSqWb9PmwnQYQA
                token-type:  Bearer
                client:  WEB

+ Response 204


## Módulo de um plano de estudo [/user/study_plan_node_modules]
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


## Módulo de um plano de estudo [/user/study_plan_node_modules/{id}]
### Atualização de um módulo de um plano de estudo [PUT]

+ Parameters
    + id: `1` (number, required) - Id da associação entre modulo e plano

+ Request (application/json)

    + Attributes

        + completed: Definição do modulo ter sido consumido ou não.
        + already_known: Indica que o usuário já sabe o módulo. Não relacionado a completude do mesmo.
        + stage_order_position: Usado para mover ou pular posições. Aceita 'up', 'down' ou 'skip'. O uso de `skip` registra a flag `skipped` na entidade.

    + Body

                {
                  "completed": "true"
                }

    + Headers

                uid:  user@integration.com
                access-token:  kaTuL76JKSqWb9PmwnQYQA
                token-type:  Bearer
                client:  WEB

+ Response 200 (application/json; charset=utf-8)
    + Body

                {
                  "data": {
                    "id": "1",
                    "type": "node-module",
                    "attributes": {
                      "node-module": "Álgebra Linear e suas Aplicações",
                      "subject": "Matemática",
                      "permalink": "enem-e-vestibulares/plano-de-estudos-1/matematica-e-suas-tecnologias/matematica/trigonometria",
                      "completed": true,
                      "already-known": false
                    }
                  }
                }


### Contadores de mídias e midias consumidas, agrupadas por node modules [GET]

+ Parameters
    + stage: (integer, optional) - Etapa desejada, é usada a atual, caso não seja informado.

+ Request (application/json)
    + Headers

                uid:  user@integration.com
                access-token:  kaTuL76JKSqWb9PmwnQYQA
                client: WEB

+ Response 200 (application/json; charset=utf-8)
    + Body

                {
                  "data": {
                    "id": "1",
                    "type": "study-plan-week",
                    "attributes": {
                      "total-medium-count": {
                        "text": 1,
                        "comprehension-exercise": 0,
                        "streaming": 0,
                        "fixation-exercise": 1,
                        "video": 1,
                        "pdf": 0,
                        "essay": 0,
                        "public-document": 0
                      },
                      "total-consumed-medium-count": {
                        "text": 0,
                        "comprehension-exercise": 0,
                        "streaming": 0,
                        "fixation-exercise": 0,
                        "video": 0,
                        "pdf": 0,
                        "essay": 0,
                        "public-document": 0
                      }
                    },
                    "relationships": {
                      "node-modules": {
                        "data": [{
                          "id": "1",
                          "type": "node-modules"
                        }]
                      }
                    }
                  },
                  "included": [{
                    "id": "1",
                    "type": "node-modules",
                    "attributes": {
                      "slug": "trigonometria",
                      "medium-count": {
                        "text": 1,
                        "comprehension-exercise": 0,
                        "streaming": 0,
                        "fixation-exercise": 1,
                        "video": 1,
                        "pdf": 0,
                        "essay": 0,
                        "public-document": 0
                      },
                      "consumed-medium-count": {
                        "text": 0,
                        "comprehension-exercise": 0,
                        "streaming": 0,
                        "fixation-exercise": 0,
                        "video": 0,
                        "pdf": 0,
                        "essay": 0,
                        "public-document": 0
                      }
                    }
                  }]
                }

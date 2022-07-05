# Study plan node modules

## Study plan node modules [/study_plan_node_modules]
### Métodos HTTP disponíveis [OPTIONS]

+ Request

    + Headers

                Origin:  http://mesalva.com
                Access-Control-Request-Method:  GET
                Access-Control-Request-Headers:  X-Requested-With

+ Response 200 (text/plain)

    + Headers

                Access-Control-Allow-Origin: http://mesalva.com
                Access-Control-Allow-Methods: OPTIONS, GET, POST, PUT, DELETE
                Access-Control-Expose-Headers: access-token, expiry, token-type, uid, client
                Access-Control-Max-Age: 1728000
                Access-Control-Allow-Credentials: true
                Access-Control-Allow-Headers: X-Requested-With
                Content-Length: 0


### Lista de todos os Study plan node modules [GET]

+ Request (application/json; charset=utf-8)
    + Headers

                uid:  admin@integration.com
                access-token:  LkoOFd6bnxRqk1xJlsQYHA
                client:  WEB

+ Response 200 (application/json; charset=utf-8)
    + Body

                {
                  "data": [{
                    "id": "1",
                    "type": "study-plan-node-modules",
                    "attributes": {
                      "position": 1,
                      "comment": "comment example",
                      "date": "2017-02-12T08:44:42.174Z",
                      "weekday": "monday",
                      "shift": "morning"
                    },
                    "relationships": {
                      "study-plan": {
                        "data": {
                          "id": "1",
                          "type": "study-plans"
                        }
                      },
                      "node-module": {
                        "data": {
                          "id": "1",
                          "type": "node-modules"
                        }
                      }
                    }
                  }
                  ]
                }


### Criação de um Study plan node module [POST]

+ Request (application/json)

    + Attributes

        + study_plan_id: id do study plan (required)
        + node_module_id: id do node module (required)
        + position: posição do node module (required)
        + comment: comentário (required)
        + date: data para inicio do estudo (required)
        + weekday: dia da semana - sunday..saturday (required)
        + shift: turno do dia - morning, mid, evening (required)

    + Body

                  {
                    "study_plan_id": 1,
                    "node_module_id": 1,
                    "position": 1,
                    "comment": "comment example",
                    "date": "2017-02-12T08:44:42.174Z",
                    "weekday": "monday",
                    "shift": "morning"
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
                    "type": "study-plan-node-modules",
                    "attributes": {
                      "position": 1,
                      "comment": "comment example",
                      "date": "2017-02-12T08:44:42.174Z",
                      "weekday": "monday",
                      "shift": "morning"
                    },
                    "relationships": {
                      "study-plan": {
                        "data": {
                          "id": "1",
                          "type": "study-plans"
                        }
                      },
                      "node-module": {
                        "data": {
                          "id": "1",
                          "type": "node-modules"
                        }
                      }
                    }
                  }
                }


## Study plan node modules [/study_plan_node_modules/{id}]
### Visualização de um Study plan node module [GET]

+ Parameters
    + id: `1` (number, required) - Id do Study plan node module

+ Request (application/json)

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
                    "type": "study-plan-node-modules",
                    "attributes": {
                      "position": 1,
                      "comment": "comment example",
                      "date": "2017-02-12T08:44:42.174Z",
                      "weekday": "monday",
                      "shift": "morning"
                    },
                    "relationships": {
                      "study-plan": {
                        "data": {
                          "id": "1",
                          "type": "study-plans"
                        }
                      },
                      "node-module": {
                        "data": {
                          "id": "1",
                          "type": "node-modules"
                        }
                      }
                    }
                  }
                }


### Atualização de um Study plan node module [PUT]

+ Parameters
    + id: `1` (number, required) - Id do Study plan node module

+ Request (application/json)

    + Attributes

        + study_plan_id: id do study plan (required)
        + node_module_id: id do node module (required)
        + position: posição do node module (required)
        + comment: comentário (required)
        + date: data para inicio do estudo (required)
        + weekday: dia da semana - sunday..saturday (required)
        + shift: turno do dia - morning, mid, evening (required)

    + Body

                  {
                    "study_plan_id": 1,
                    "node_module_id": 1,
                    "position": 1,
                    "comment": "comment example",
                    "date": "2017-02-12T08:44:42.174Z",
                    "weekday": "monday",
                    "shift": "morning"
                  }
    + Headers

                uid:  admin@integration.com
                access-token:  LkoOFd6bnxRqk1xJlsQYHA
                client:  WEB

+ Response 200 (application/json; charset=utf-8)
    + Body

                {
                  "data": {
                    "id": "1",
                    "type": "study-plan-node-modules",
                    "attributes": {
                      "position": 1,
                      "comment": "comment example",
                      "date": "2017-02-12T08:44:42.174Z",
                      "weekday": "monday",
                      "shift": "morning"
                    },
                    "relationships": {
                      "study-plan": {
                        "data": {
                          "id": "1",
                          "type": "study-plans"
                        }
                      },
                      "node-module": {
                        "data": {
                          "id": "1",
                          "type": "node-modules"
                        }
                      }
                    }
                  }
                }


### Remoção de um Study plan node module [DELETE]

+ Parameters
    + id: `1` (number, required) - Id do Study plan node module

+ Request (application/json)
    + Headers

                uid:  admin@integration.com
                access-token:  LkoOFd6bnxRqk1xJlsQYHA
                client:  WEB

+ Response 204

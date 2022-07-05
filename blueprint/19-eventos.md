# Group Eventos

## Eventos de usuário [/events/user/last_modules{?page,education_segment}]
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


### Meus módulos: contagem de mídias distintas consumidas, agrupadas por módulo, com detalhes [GET]

+ Parameters
    + page: (integer, optional) - Paginação
    + education_segment: (string, optional)

+ Request (application/json)
    + Headers

                uid:  user@integration.com
                access-token:  kaTuL76JKSqWb9PmwnQYQA
                client: WEB
                Total: 36
                Per-Page: 10
                Link: <https://apiv2.mesalva.com/events/user/last_modules?page=1>; rel="first", <https://apiv2.mesalva.com/events/user/last_modules?page=1>; rel="prev", <https://apiv2.mesalva.com/events/user/last_modules?page=4>; rel="last", <https://apiv2.mesalva.com/events/user/last_modules?page=3>; rel="next"

+ Response 200 (application/json; charset=utf-8)
    + Body

                {
                  "results": [{
                    "permalink": "new-education-segment/new-subject/new-node-module",
                      "node": {
                        "name": "New Education Segment",
                        "slug": "new-education-segment"
                      },
                      "node-module": {
                        "name": "New Node Module",
                        "slug": "new-node-module"
                      },
                      "medium-count": {
                        "text": 0,
                        "comprehension-exercise": 0,
                        "fixation-exercise": 10,
                        "video": 10,
                        "pdf": 0,
                        "essay": 0
                      }
                  }]
                }

### Registrar texto lido para medium tipo text via permalink [POST]

+ Parameters
    + id: `enem-e-vestibulares/plano-de-estudos-1/matematica-e-suas-tecnologias/matematica/trigonometria/quem-foi-pitagoras/texto-basico-1` (string, required) - permalinks/{id}

+ Request (application/json)

    + Headers

                uid:  user@integration.com
                access-token:  kaTuL76JKSqWb9PmwnQYQA
                client:  WEB
                location: -2.74, 63.21
                platform: IOS
                device: iPhone 6S
                user_agent: meSalva/2.1(20161109.1.497) (iPhone 5; pt) iPhone OS/8.4
                utm-source: enem
                utm-medium: 320banner
                utm-term: matematica
                utm-content: textlink
                utm-campaign: mkt


    + Body

                {
                  "event_name": "text_read"
                }

+ Response 200 (application/json; charset=utf-8)
    + Body

              {
                "data": {
                  "id": "6",
                    "type": "permalinks",
                    "attributes": {
                      "slug": "enem-e-vestibulares/plano-de-estudos-1/matematica-e-suas-tecnologias/matematica/trigonometria/quem-foi-pitagoras/texto-basico-1"
                    }
                }
              }


### Registrar aula assistida para medium tipo video via permalink [POST]

+ Parameters
    + id: `enem-e-vestibulares/plano-de-estudos-1/matematica-e-suas-tecnologias/matematica/trigonometria/o-que-e-um-triangulo/video-basico-1` (string, required) - permalinks/{id}

+ Request (application/json)
    + Headers

                uid:  user@integration.com
                access-token:  kaTuL76JKSqWb9PmwnQYQA
                client:  WEB
                location: -2.74, 63.21
                platform: IOS
                device: iPhone 6S
                user_agent: meSalva/2.1(20161109.1.497) (iPhone 5; pt) iPhone OS/8.4
                utm-source: enem
                utm-medium: 320banner
                utm-term: matematica
                utm-content: textlink
                utm-campaign: mkt


    + Body

                {
                  "event_name": "lesson_watch"
                }

+ Response 200 (application/json; charset=utf-8)
    + Body

              {
                "data": {
                  "id": "6",
                  "type": "permalinks",
                  "attributes": {
                    "slug": "enem-e-vestibulares/plano-de-estudos-1/matematica-e-suas-tecnologias/matematica/trigonometria/o-que-e-um-triangulo/video-basico-1"
                  }
                }
              }


### Avaliar aula atraves de permalink [POST]

+ Parameters
    + id: `enem-e-vestibulares/plano-de-estudos-1/matematica-e-suas-tecnologias/matematica/trigonometria/o-que-e-um-triangulo/video-basico-1` (string, required) - permalinks/{id}

+ Request (application/json)
    + Headers

                uid:  user@integration.com
                access-token:  kaTuL76JKSqWb9PmwnQYQA
                client:  WEB
                location: -2.74, 63.21
                platform: IOS
                device: iPhone 6S
                user_agent: meSalva/2.1(20161109.1.497) (iPhone 5; pt) iPhone OS/8.4
                utm-source: enem
                utm-medium: 320banner
                utm-term: matematica
                utm-content: textlink
                utm-campaign: mkt

    + Body

                {
                  "event_name": "content_rate",
                  "rating": 4
                }

+ Response 200 (application/json; charset=utf-8)
    + Body

              {
                "data": {
                  "id": "7",
                    "type": "permalinks",
                    "attributes": {
                      "slug": "enem-e-vestibulares/plano-de-estudos-1/matematica-e-suas-tecnologias/matematica/trigonometria/o-que-e-um-triangulo/video-basico-1"
                    }
                }
              }


##  Eventos de Feature [/user/feature_events]
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


### Criação de evento de próximo módulo para uma feature [POST]

+ Request (application/json)
    + Headers

                uid:  user@integration.com
                access-token:  kaTuL76JKSqWb9PmwnQYQA
                token-type:  Bearer
                client:  WEB

    + Body

                {
                  "feature": "syllabus",
                  "section": "extensivo-enem",
                  "context": "next",
                  "module": {
                    "name": "NNIN - Ciencias da Natureza: O que sao?",
                    "slug": "nnin-introducao-as-ciencias-da-natureza-apresentacao",
                    "permalink": "enem-e-vestibulares/materias/ciencias-da-natureza-e-suas-tecnologias/interdisciplinar-ciencias-da-natureza/completo/introducao-as-ciencias-da-natureza/nnin-introducao-as-ciencias-da-natureza-apresentacao",
                    "number": "1"
                  }
                }

+ Response 201 (application/json; charset=utf-8)
    + Body

                {
                  "data": {
                    "id": "user@integration.com",
                    "type": "next",
                    "attributes": {
                      "name": "NNIN - Ciencias da Natureza: O que sao?",
                      "slug": "nnin-introducao-as-ciencias-da-natureza-apresentacao",
                      "permalink": "enem-e-vestibulares/materias/ciencias-da-natureza-e-suas-tecnologias/interdisciplinar-ciencias-da-natureza/completo/introducao-as-ciencias-da-natureza/nnin-introducao-as-ciencias-da-natureza-apresentacao",
                      "number": "1"
                    }
                  }
                }


### Visualização dos módulos consumidos em uma semana [GET]

+ Parameters
    + feature: `syllabus` (string, required)
    + section: `extensivo-enem` (string, required)
    + context: `week.1` (string, optional)

+ Request (application/json)
    + Headers

                uid:  user@integration.com
                access-token:  kaTuL76JKSqWb9PmwnQYQA
                client:  WEB

    + Body
                {
                  "feature": "syllabus",
                  "section": "extensivo-medicina",
                  "context": "week.1"
                }

+ Response 200 (application/json; charset=utf-8)
    + Body

                {
                  "data": {
                    "id": "user@integration.com",
                    "type": "week",
                    "attributes": {
                      "modules": [
                        "nnin-introducao-as-ciencias-da-natureza-apresentacao"
                      ]
                    }
                  }
                }


##  Eventos de Feature [/user/feature_events/next]
### Visualização do próximo módulo a ser consumido em uma feature [GET]

+ Parameters
    + feature: `syllabus` (string, required)
    + section: `extensivo-enem` (string, required)
    + context: `next` (string, optional)

+ Request (application/json)
    + Headers

                uid:  user@integration.com
                access-token:  kaTuL76JKSqWb9PmwnQYQA
                client:  WEB

    + Body
                {
                  "feature": "syllabus",
                  "section": "extensivo-enem",
                  "context": "next"
                }

+ Response 200 (application/json; charset=utf-8)
    + Body

                {
                  "data": {
                    "id": "user@integration.com",
                    "type": "next",
                    "attributes": {
                      "name": "NNIN - Ciencias da Natureza: O que sao?",
                      "slug": "nnin-introducao-as-ciencias-da-natureza-apresentacao",
                      "permalink": "enem-e-vestibulares/materias/ciencias-da-natureza-e-suas-tecnologias/interdisciplinar-ciencias-da-natureza/completo/introducao-as-ciencias-da-natureza/nnin-introducao-as-ciencias-da-natureza-apresentacao",
                      "number": "1"
                    }
                  }
                }

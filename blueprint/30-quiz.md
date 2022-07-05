# Group Quiz

## Quiz Forms [/quiz/forms]
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


### Lista de todos os quiz forms [GET]

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
                    "type": "quiz-forms",
                    "attributes": {
                      "name": "Questionário plano de estudos",
                      "description": "Plano de estudos ENEM",
                      "active": true,
                      "form-type": "study_plan"
                    }
                  }, {
                    "id": "2",
                    "type": "quiz-forms",
                    "attributes": {
                      "name": "Questionário plano de estudos",
                      "description": "Plano de estudos ENEM",
                      "active": true,
                      "form-type": "study_plan"
                    }
                  }]
                }


### Criação de um Quiz Form [POST]

+ Request (application/json)

    + Attributes

        + name: Nome do questionário (required)
        + description: Descrição do questionário (required)
        + active: Status de exibição do questionário
        + form_type: Tipo do questionário (required)

    + Body

                {
                  "name": "Questionário plano de estudos",
                  "description": "Plano de estudos ENEM",
                  "active": "true",
                  "form_type": "study_plan"
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
                    "type": "quiz-forms",
                    "attributes": {
                      "name": "Questionário plano de estudos",
                      "description": "Plano de estudos ENEM",
                      "active": true,
                      "form-type": "study_plan"
                    }
                  }
                }


## Quiz Forms [/quiz/forms/{id}]
### Visualização de um Quiz Form [GET]

+ Parameters
    + id: `1` (number, required) - Id do form

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
                    "type": "quiz-forms",
                    "attributes": {
                      "name": "Quiz form",
                      "description": "Quiz form",
                      "active": true,
                      "form-type": "study_plan"
                    },
                    "relationships": {
                      "questions": {
                        "data": [{
                          "id": "18",
                          "type": "quiz-questions"
                        }]
                      }
                    }
                  },
                  "included": [{
                    "id": "18",
                    "type": "quiz-questions",
                    "attributes": {
                      "statement": "Quiz form question",
                      "question-type": "checkbox",
                      "description": "Breve explicação da pergunta",
                      "required": false
                    },
                    "relationships": {
                      "alternatives": {
                        "data": []
                      },
                      "form": {
                        "data": {
                          "id": "1",
                          "type": "quiz-forms"
                        }
                      }
                    }
                  }]
                }



### Atualização de um Quiz Form [PUT]

+ Parameters
    + id: `1` (number, required) - Id do form

+ Request (application/json)

    + Attributes

        + name: Nome do questionário
        + description: Descrição do questionário
        + active: Status de exibição do questionário
        + form_type: Tipo do questionário

    + Body

                {
                  "active": "false"
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
                    "type": "quiz-forms",
                    "attributes": {
                      "name": "Questionário plano de estudos",
                      "description": "Plano de estudos ENEM",
                      "active": false,
                      "form-type": "study_plan"
                    }
                  }
                }


### Remoção de um Quiz Form [DELETE]

+ Parameters
    + id: `1` (number, required) - Id do form

+ Request (application/json)
    + Headers

                uid:  admin@integration.com
                access-token:  LkoOFd6bnxRqk1xJlsQYHA
                client:  WEB

+ Response 204


## Quiz Questions [/quiz/questions]
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


### Lista de todos os quiz questions [GET]

+ Request (application/json; charset=utf-8)
    + Headers

                uid:  admin@integration.com
                access-token:  LkoOFd6bnxRqk1xJlsQYHA
                client:  WEB

+ Response 200 (application/json; charset=utf-8)
    + Body

                {
                  "data": [{
                    "id": "2",
                    "type": "quiz-questions",
                    "attributes": {
                      "statement": "Quiz form question",
                      "question-type": "checkbox",
                      "description": "",
                      "required": false
                    },
                    "relationships": {
                      "form": {
                        "data": {
                          "id": "1",
                          "type": "quiz-forms"
                        }
                      }
                    }
                  }]
                }


### Criação de um Quiz Question [POST]

+ Request (application/json)

    + Attributes

        + quiz_form_id: ID do questionário pai (required)
        + statement: Descrição da pergunta (required)
        + question_type: Tipo da questão
        + description: Breve explicação sobre o que é a pergunta
        + position: Posição da questão no formulário

    + Body

                {
                  "quiz_form_id": 1,
                  "statement": "Quiz form question",
                  "question_type": "checkbox",
                  "description": "Breve explicação da pergunta",
                  "position": 1,
                  "required": false
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
                    "type": "quiz-questions",
                    "attributes": {
                      "statement": "Quiz form question",
                      "question-type": "checkbox",
                      "description": "Breve explicação da pergunta",
                      "required": false
                    },
                    "relationships": {
                      "form": {
                        "data": {
                          "id": "1",
                          "type": "quiz-forms"
                        }
                      }
                    }
                  }
                }


## Quiz Questions [/quiz/questions/{id}]
### Visualização de um Quiz Question [GET]

+ Parameters
    + id: `11` (number, required) - Id do question

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
                    "id": "2",
                    "type": "quiz-questions",
                    "attributes": {
                      "statement": "Quiz form question",
                      "question-type": "checkbox",
                      "description": "Breve explicação da pergunta",
                      "required": false
                    },
                    "relationships": {
                      "form": {
                        "data": {
                          "id": "1",
                          "type": "quiz-forms"
                        }
                      }
                    }
                  }
                }


### Atualização de um Quiz Question [PUT]

+ Parameters
    + id: `1` (number, required) - Id do question

+ Request (application/json)

    + Attributes

        + quiz_form_id: ID do questionário pai
        + statement: Descrição da pergunta
        + question_type: Tipo da questão
        + description: Breve explicação sobre o que é a pergunta
        + position: Posição da questão no formulário

    + Body

                {
                  "statement": "New question statement",
                  "question_type": "radio"
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
                    "type": "quiz-questions",
                    "attributes": {
                      "statement": "New question statement",
                      "question-type": "radio",
                      "description": "explicação da questão",
                      "required": false
                    },
                    "relationships": {
                      "alternatives": {
                        "data": [{
                          "id": "10",
                          "type": "quiz-alternatives"
                        }]
                      },
                      "form": {
                        "data": {
                          "id": "2",
                          "type": "quiz-forms"
                        }
                      }
                    }
                  }
                }


### Remoção de um Quiz Question [DELETE]

+ Parameters
    + id: `11` (number, required) - Id da alternative

+ Request (application/json)
    + Headers

                uid:  admin@integration.com
                access-token:  LkoOFd6bnxRqk1xJlsQYHA
                client:  WEB

+ Response 204


## Quiz Alternatives [/quiz/alternatives]
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


### Lista de todos os quiz alternatives [GET]

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
                    "type": "quiz-alternatives",
                    "attributes": {
                      "description": "Alternative",
                      "value": "val"
                    }
                  }, {
                    "id": "2",
                    "type": "quiz-alternatives",
                    "attributes": {
                      "description": "Quiz alternative",
                      "value": "alt1"
                    }
                  }]
                }


### Criação de um Quiz Alternative [POST]

+ Request (application/json)

    + Attributes

        + quiz_question_id: ID da questão pai (required)
        + description: Descrição da alternativa (required)
        + value: Valor da alternativa, para uso interno (required)

    + Body

                {
                  "quiz_question_id": 11,
                  "description": "Quiz alternative",
                  "value": "alt1"
                }

    + Headers

                uid:  admin@integration.com
                access-token:  LkoOFd6bnxRqk1xJlsQYHA
                client:  WEB

+ Response 201 (application/json; charset=utf-8)
    + Body

                {
                  "data": {
                    "id": "2",
                    "type": "quiz-alternatives",
                    "attributes": {
                      "description": "Quiz alternative",
                      "value": "alt1"
                    }
                  }
                }


## Quiz Alternatives [/quiz/alternatives/{id}]
### Visualização de um Quiz Alternative [GET]

+ Parameters
    + id: `1001` (number, required) - Id da alternative

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
                    "id": "2",
                    "type": "quiz-alternatives",
                    "attributes": {
                      "description": "Quiz alternative",
                      "value": "alt1"
                    }
                  }
                }


### Atualização de um Quiz Alternative [PUT]

+ Parameters
    + id: `1001` (number, required) - Id da alternative

+ Request (application/json)

    + Attributes

        + quiz_question_id: ID da questão pai
        + description: Descrição da alternativa
        + value: Valor da alternativa, para uso interno

    + Body

                {
                  "description": "New alternative description"
                }

    + Headers

                uid:  admin@integration.com
                access-token:  LkoOFd6bnxRqk1xJlsQYHA
                client:  WEB

+ Response 200 (application/json; charset=utf-8)
    + Body

                {
                  "data": {
                    "id": "2",
                    "type": "quiz-alternatives",
                    "attributes": {
                      "description": "New alternative description",
                      "value": "alt1"
                    }
                  }
                }


### Remoção de um Quiz Alternative [DELETE]

+ Parameters
    + id: `1005` (number, required) - Id da alternative

+ Request (application/json)
    + Headers

                uid:  admin@integration.com
                access-token:  LkoOFd6bnxRqk1xJlsQYHA
                client:  WEB

+ Response 204


## Quiz Form Submission [/quiz/form_submissions]
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


### Lista de todos os quiz form submissions [GET]

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
                    "type": "quiz-form-submissions",
                    "relationships": {
                      "form": {
                        "data": {
                          "id": "4",
                          "type": "quiz-forms"
                        }
                      },
                      "user": {
                        "data": {
                          "id": "user1@mesalva.com",
                          "type": "users"
                        }
                      }
                    }
                  }, {
                    "id": "2",
                    "type": "quiz-form-submissions",
                    "relationships": {
                      "form": {
                        "data": {
                          "id": "1",
                          "type": "quiz-forms"
                        }
                      },
                      "user": {
                        "data": {
                          "id": "user@integration.com",
                          "type": "users"
                        }
                      }
                    }
                  }]
                }


### Criação de um Form Submission [POST]

+ Request (application/json)

    + Attributes

        + quiz_form_id: ID do form pai (required)

    + Body

                {
                  "quiz_form_id": 11,
                  "answers_attributes": [
                    {
                      "quiz_question_id": 6,
                      "quiz_alternative_id": 1000
                    },
                    {
                      "quiz_question_id": 11,
                      "value": "sample answer"
                    },
                    {
                      "quiz_question_id": 12,
                      "value": "2017-09-15 16:19:13 -0300"
                    },
                    {
                      "quiz_question_id": 13,
                      "value": "enem|2017-10-19 16:20:19 -0300"
                    }
                  ]
                }

    + Headers

                uid:  user@integration.com
                access-token:  kaTuL76JKSqWb9PmwnQYQA
                token-type:  Bearer
                client:  WEB

+ Response 201 (application/json; charset=utf-8)
    + Body

                {
                  "data": {
                    "id": "1",
                    "type": "quiz-form-submissions",
                    "relationships": {
                      "answers": {
                        "data": [
                          {
                            "id": "1",
                            "type": "quiz-answers"
                          },
                          {
                            "id": "2",
                            "type": "quiz-answers"
                          }
                        ]
                      },
                      "form": {
                        "data": {
                          "id": "3",
                          "type": "quiz-forms"
                        }
                      },
                      "user": {
                        "data": {
                          "id": "user1@mesalva.com",
                          "type": "users"
                        }
                      }
                    }
                  }
                }


## Quiz Form Submission [/quiz/form_submissions/{id}]
### Visualização de um Quiz Form Submission [GET]

+ Parameters
    + id: `1` (number, required) - Id do form_submission

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
                    "type": "quiz-form-submissions",
                    "relationships": {
                      "form": {
                        "data": { "id": "4", "type": "quiz-forms"
                        }
                      },
                      "user": {
                        "data": {
                          "id": "user1@mesalva.com",
                          "type": "users"
                        }
                      }
                    }
                  }
                }


## Quiz Form Submission [/quiz/forms/{form_id}/form_submissions]
### Visualização do último Quiz Form Submission de um Form [GET]

+ Parameters
    + form_id: `1` (number, required) - Id do form

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
                    "type": "quiz-form-submissions",
                    "relationships": {
                      "answers": {
                        "data": [
                          {
                            "id": "1",
                            "type": "quiz-answers"
                          },
                          {
                            "id": "2",
                            "type": "quiz-answers"
                          }
                        ]
                      },
                      "form": {
                        "data": {
                          "id": "1",
                          "type": "quiz-forms"
                        }
                      },
                      "user": {
                        "data": {
                          "id": "user1@mesalva.com",
                          "type": "users"
                        }
                      }
                    }
                  },
                  "included": [{
                    "id": "1",
                    "type": "quiz-answers",
                    "attributes": {
                      "quiz-alternative-id": 1,
                      "value": "answer value",
                      "quiz-question-id": 1
                    },
                    "relationships": {
                      "question": {
                        "data": {
                          "id": "1",
                          "type": "quiz-questions"
                        }
                      },
                      "alternative": {
                        "data": {
                          "id": "1",
                          "type": "quiz-alternatives"
                        }
                      },
                      "form-submission": {
                        "data": {
                          "id": "1",
                          "type": "quiz-form-submissions"
                        }
                      }
                    }
                  }]
                }

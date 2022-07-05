# Group Perfis

## Estudantes [/user/profiles]
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


### Consulta de perfil do estudante [GET]
+ Request (application/json)
    + Headers

                uid:  user@integration.com
                access-token:  kaTuL76JKSqWb9PmwnQYQA
                client:  WEB


+ Response 200 (application/json; charset=utf-8)
    + Body

                {
                  "data": {
                    "id": "user@integration.com",
                    "type": "users",
                    "attributes": {
                      "provider": "email",
                      "uid": "user@integration.com",
                      "name": null,
                      "image": {
                        "url": "https://cdnqa.mesalva.com/uploads/user/image/integration.png"
                      },
                      "email": "user@integration.com",
                      "birth-date": null,
                      "gender": null,
                      "studies": null,
                      "dreams": null,
                      "premium": false,
                      "origin": null,
                      "active": true,
                      "created-at" : "2017-02-12T08:44:42.174Z"
                    },
                    "relationships": {
                      "address": {
                        "data": null
                      },
                      "academic-info": {
                        "data": null
                      },
                      "education-level": {
                        "data": null
                      },
                      "objective": {
                        "data": null
                      }
                    }
                  }
                }


### Atualização de estudante [PUT]
Arquivos enviados devem ser codificados em base64 e formatados em Data URI scheme format: `data:image/jpeg;base64,(base64 encoded data)`

+ Request (application/json)
    + Body

                {
                  "name": "Novo nome com atributo",
                  "birth_date": "26-02-1994",
                  "gender": "Masculino",
                  "studies": "Complementar",
                  "dreams": "Quero estudar design automotivo para poder desenhar meus próprios carros",
                  "origin": "Indicação de um amigo",
                  "objective_id": 1,
                  "education_level_id": 1,
                  "image": "data:image/jpeg;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP4z8DwHwAFAAH/VscvDQAAAABJRU5ErkJggg==",
                  "address_attributes": {
                    "street": "Rua Padre Chagas",
                    "street_number": "79",
                    "street_detail": "302",
                    "neighborhood": "Moinhos de Vento",
                    "city": "Porto Alegre",
                    "zip_code": "91920-000",
                    "state": "RS",
                    "country": "Brasil",
                    "area_code": "11",
                    "phone_number": "979911992"
                  },
                  "academic_info_attributes": {
                    "agenda": "10/12/2016 - Exame de cálculo",
                    "current_school": "UFRGS",
                    "current_school_courses": "Arquitetura",
                    "desired_courses": "Engenharia Ambiental",
                    "school_appliances": "ENEM",
                    "school_appliance_this_year": "Sim",
                    "favorite_school_subjects": "Matemática",
                    "difficult_learning_subjects": "Redação",
                    "current_academic_activities": "Cálculo diferencial e integral",
                    "next_academic_activities": "Física II"
                  }
                }

    + Headers

                uid:  user@integration.com
                access-token:  kaTuL76JKSqWb9PmwnQYQA
                client:  WEB


+ Response 200 (application/json; charset=utf-8)
    + Body

                {
                  "data": {
                    "id": "user@integration.com",
                    "type": "users",
                    "attributes": {
                      "provider": "email",
                      "uid": "user@integration.com",
                      "name": "Novo nome com atributo",
                      "image": {
                        "url": "https://cdnqa.mesalva.com/uploads/user/image/integration.jpeg"
                      },
                      "email": "user@integration.com",
                      "birth-date": "26-02-1994",
                      "gender": "Masculino",
                      "studies": "Complementar",
                      "dreams": "Quero estudar design automotivo para poder desenhar meus próprios carros",
                      "premium": false,
                      "origin": "Indicação de um amigo",
                      "active": true,
                      "created-at" : "2017-02-12T08:44:42.174Z"
                    },
                    "relationships": {
                      "address": {
                        "data": {
                          "id": "3",
                          "type": "addresses"
                        }
                      },
                      "academic-info": {
                        "data": {
                          "id": "1",
                          "type": "academic-infos"
                        }
                      },
                      "education-level": {
                        "data": {
                          "id": "1",
                          "type": "education-levels"
                        }
                      },
                      "objective": {
                        "data": {
                          "id": "1",
                          "type": "objectives"
                        }
                      }
                    }
                  },
                  "included": [{
                    "id": "3",
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
                  }, {
                    "id": "1",
                    "type": "academic-infos",
                    "attributes": {
                      "agenda": "10/12/2016 - Exame de cálculo",
                      "current-school": "UFRGS",
                      "current-school-courses": "Arquitetura",
                      "desired-courses": "Engenharia Ambiental",
                      "school-appliances": "ENEM",
                      "school-appliance-this-year": "Sim",
                      "favorite-school-subjects": "Matemática",
                      "difficult-learning-subjects": "Redação",
                      "current-academic-activities": "Cálculo diferencial e integral",
                      "next-academic-activities": "Física II"
                    }
                  }, {
                    "id": "1",
                    "type": "education-levels",
                    "attributes": {
                      "name": "Ensino fundamental em andamento"
                    }
                  }, {
                    "id": "1",
                    "type": "objectives",
                    "attributes": {
                      "name": "Estudar para o ensino fundamental",
                      "education-segment-slug": null
                    }
                  }]
                }


## Ações de administrador [/user/profiles?uid=user@integration.com]
### Busca de perfil do estudante [GET]


+ Request (application/json)
    + Headers

                uid:  admin@integration.com
                access-token:  LkoOFd6bnxRqk1xJlsQYHA
                client:  WEB

+ Response 200 (application/json; charset=utf-8)
    + Body

                {
                  "data": {
                    "id": "user@integration.com",
                    "type": "users",
                    "attributes": {
                      "provider": "email",
                      "uid": "user@integration.com",
                      "name": null,
                      "image": {
                        "url": "https://cdnqa.mesalva.com/uploads/user/image/integration.png"
                      },
                      "email": "user@integration.com",
                      "birth-date": null,
                      "gender": null,
                      "studies": null,
                      "dreams": null,
                      "premium": false,
                      "origin": null,
                      "active": true
                    },
                    "relationships": {
                      "address": {
                        "data": null
                      },
                      "academic-info": {
                        "data": null
                      },
                      "education-level": {
                        "data": null
                      },
                      "objective": {
                        "data": null
                      }
                    }
                  }
                }


### Atualização de estudante [PUT]

+ Request (application/json)

    + Body

                {
                  "user": {
                    "uid": "user@integration.com",
                    "name": "Novo nome pelo admin",
                    "birth_date": "26-02-1994",
                    "gender": "Masculino",
                    "studies": "Complementar",
                    "dreams": "Quero estudar design automotivo para poder desenhar meus próprios carros",
                    "origin": "Indicação de um amigo",
                    "objective_id": 1,
                    "education_level_id": 1
                  }
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
                    "type": "users",
                    "attributes": {
                      "provider": "email",
                      "uid": "user@integration.com",
                      "name": "Novo nome pelo admin",
                      "image": {
                        "url": "https://cdnqa.mesalva.com/uploads/user/image/integration.png"
                      },
                      "email": "user@integration.com",
                      "birth-date": "26-02-1994",
                      "gender": "Masculino",
                      "studies": "Complementar",
                      "dreams": "Quero estudar design automotivo para poder desenhar meus próprios carros",
                      "premium": false,
                      "origin": "Indicação de um amigo",
                      "active": true
                    },
                    "relationships": {
                      "address": {
                        "data": {
                          "id": "3",
                          "type": "addresses"
                        }
                      },
                      "academic-info": {
                        "data": {
                          "id": "1",
                          "type": "academic-infos"
                        }
                      },
                      "education-level": {
                        "data": {
                          "id": "1",
                          "type": "education-levels"
                        }
                      },
                      "objective": {
                        "data": {
                          "id": "1",
                          "type": "objectives"
                        }
                      }
                    }
                  },
                  "included": [{
                    "id": "3",
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
                  }, {
                    "id": "1",
                    "type": "academic-infos",
                    "attributes": {
                      "agenda": "10/12/2016 - Exame de cálculo",
                      "current-school": "UFRGS",
                      "current-school-courses": "Arquitetura",
                      "desired-courses": "Engenharia Ambiental",
                      "school-appliances": "ENEM",
                      "school-appliance-this-year": "Sim",
                      "favorite-school-subjects": "Matemática",
                      "difficult-learning-subjects": "Redação",
                      "current-academic-activities": "Cálculo diferencial e integral",
                      "next-academic-activities": "Física II"
                    }
                  }, {
                    "id": "1",
                    "type": "education-levels",
                    "attributes": {
                      "name": "Ensino fundamental em andamento"
                    }
                  }, {
                    "id": "1",
                    "type": "objectives",
                    "attributes": {
                      "name": "Estudar para o ensino fundamental",
                      "education-segment-slug": null
                    }
                  }]
                }


## Professores [/teacher/profiles]
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


### Atualização de professor [PUT]

+ Request (application/json)

    + Body

                {
                  "teacher": {
                    "name": "Novo nome de professor",
                    "nickname": "Rafa",
                    "description": "Professor de biologia",
                    "birth_date": "12-05-1992"
                  }
                }

    + Headers

                uid: teacher@integration.com
                access-token: LkoOFd6bnxRqk1xJlsQYHA
                client:  WEB

+ Response 200 (application/json; charset=utf-8)

                {
                  "data": {
                    "id": "teacher@integration.com",
                    "type": "teachers",
                    "attributes": {
                      "uid": "teacher@integration.com",
                      "name": "Novo nome de professor",
                      "image": {
                        "url": null
                      },
                      "email": "teacher@integration.com",
                      "description": "Professor de biologia",
                      "birth-date": "12-05-1992",
                      "active": true
                    }
                  }
                }


## Ações de administrador [/teacher/profiles?uid=teacher@integration.com]
### Buscar perfil de professor como um administrador [GET]

+ Request (application/json)

    + Headers

                uid:  admin@integration.com
                access-token:  LkoOFd6bnxRqk1xJlsQYHA
                client:  WEB

+ Response 200 (application/json; charset=utf-8)

    + Body

                {
                  "data": {
                    "id": "teacher@integration.com",
                    "type": "teachers",
                    "attributes": {
                      "uid": "teacher@integration.com",
                      "name": null,
                      "image": {
                        "url": null
                      },
                      "email": "teacher@integration.com",
                      "description": null,
                      "birth-date": null,
                      "active": true
                    }
                  }
                }


## Administradores [/admin/profiles]
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


### Atualização de administrador [PUT]

+ Request (application/json)

    + Body

                {
                  "admin": {
                    "name": "Novo nome de admin",
                    "nickname": "Cadu",
                    "description": "Administrador do forum",
                    "birth_date": "24-01-1991"
                  }
                }

    + Headers

                uid:  admin@integration.com
                access-token:  LkoOFd6bnxRqk1xJlsQYHA
                client:  WEB

+ Response 200 (application/json; charset=utf-8)

                {
                  "data": {
                    "id": "admin@integration.com",
                    "type": "admins",
                    "attributes": {
                      "uid": "admin@integration.com",
                      "name": "Novo nome de admin",
                      "image": {
                        "url": null
                      },
                      "email": "admin@integration.com",
                      "description": "Administrador do forum",
                      "birth-date": "24-01-1991",
                      "active": true
                    }
                  }
                }

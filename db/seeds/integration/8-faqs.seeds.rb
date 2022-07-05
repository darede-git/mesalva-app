general_faq = Faq.create!(name: 'Geral',
													slug: 'me-salva',
													token: 'abcdefgh')

specific_faq = Faq.create!(name: 'ENEM e vestibulares',
													 slug: 'enem-e-vestibulares',
													 token: 'OFd6bnxRqk1xJlsQYha')

general_question = Question.create!(title: 'O que é o Me Salva!?',
							  		           			answer: 'É uma plataforma de estudos online',
							       			   			  created_by: 'admin@mesalva.com',
							            					updated_by: 'admin2@mesalva.com',
							           			      image: 'data:image/jpeg;base64,iVBORw0KGgoAAAANSUhE"\
"UgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP4z8DwHwAFAAH/VscvDQAAAABJRU5ErkJggg==',
																    faq_id: general_faq.id,
														   			token: 'OFd6bnxRqk1xJlsQYHA')

specific_question = Question.create!(title: 'A quais módulos tenho acesso?',
																		 answer: 'Matemática, Linguagens, Natureza e Humanas',
																		 created_by: 'admin@mesalva.com',
																		 updated_by: nil,
																		 image:'data:image/jpeg;base64,iVBORw0KGgoAAAANSUhE"\
"UgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP4z8DwHwAFAAH/VscvDQAAAABJRU5ErkJggg==',
																		 faq_id: specific_faq.id)

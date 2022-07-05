# frozen_string_literal: true

require 'me_salva/permalinks/builder'

platform = Node.new(
  name: 'Me Salva!',
  node_type: 'platform',
  description: 'Me Salva'
)
platform.save(validate: false)

education_segment = Node.create!(
  name: 'Enem e Vestibulares',
  node_type: 'education_segment',
  parent_id: platform.id,
  position: 1
)

study_plan = Node.create!(
  name: 'Plano de estudos 1',
  node_type: 'study_plan',
  parent_id: education_segment.id
)

area = Node.create!(
  name: 'Matemática e suas tecnologias',
  node_type: 'area',
  parent_id: study_plan.id,
  color_hex: 'ED4343'
)

course = Node.create!(
  name: 'Matemática',
  node_type: 'area_subject',
  parent_id: area.id,
  color_hex: 'ED4343'
)

node_module1 = NodeModule.create!(
  name: 'Trigonometria',
  node_ids: [course.id],
  code: 'alg01',
  description: 'Álgebra linear é um ramo da matemática que surgiu do '\
  'estudo detalhado de sistemas de equações lineares, sejam elas '\
  'algébricas ou diferenciais.',
  suggested_to: 'Estudantes da disciplina de matemática',
  pre_requisite: 'Saber ler e escrever',
  instructor: Teacher.find(2),
  position: 1
)

item1 = Item.create!(
  name: 'O que é um triângulo?',
  node_module_ids: [node_module1.id],
  description: 'item basico',
  free: true,
  active: true,
  code: 'BAS',
  created_by: User.first.id,
  updated_by: User.first.id,
  item_type: 'video'
)

Medium.create!(
  name: 'Vídeo Basico 1',
  item_ids: [item1.id],
  medium_type: 'video',
  seconds_duration: 15,
  video_id: 'Vw8R8gCNMoI',
  provider: 'youtube'
)

item_text = Item.create!(
  name: 'Quem foi Pitagoras?',
  node_module_ids: [node_module1.id],
  description: 'item basico texto',
  free: true,
  active: true,
  code: 'BAS',
  created_by: User.first.id,
  updated_by: User.first.id,
  item_type: 'text'
)

Medium.create!(
  name: 'Texto basico 1',
  item_ids: [item_text.id],
  medium_type: 'text',
  medium_text: 'Esta é uma aula em texto'
)

item_exercise = Item.create!(
  name: 'Exercicios de trigo',
  node_module_ids: [node_module1.id],
  description: 'item basico exercicio',
  free: true,
  active: true,
  code: 'BAS',
  created_by: User.first.id,
  updated_by: User.first.id,
  item_type: 'fixation_exercise'
)

Medium.create!(
  name: 'Exercício 1',
  item_ids: [item_exercise.id],
  medium_type: 'fixation_exercise',
  audit_status: 'reviewed',
  medium_text: 'Sample text',
  correction: 'Sample correction',
  answers_attributes: [
    { text: 'alternativa 1', correct: true },
    { text: 'alternativa 2', correct: false },
    { text: 'alternativa 3', correct: false },
    { text: 'alternativa 4', correct: false },
    { text: 'alternativa 5', correct: false }
  ]
)

node_module = NodeModule.create!(
  name: 'Álgebra Linear',
  node_ids: [course.id],
  code: 'alg01',
  description: 'Álgebra linear é um ramo da matemática que surgiu do '\
  'estudo detalhado de sistemas de equações lineares, sejam elas '\
  'algébricas ou diferenciais.',
  suggested_to: 'Estudantes da disciplina de matemática',
  pre_requisite: 'Saber ler e escrever',
  instructor: Teacher.find(2),
  position: 2
)

item = Item.create!(
  name: 'Álgebra Linear Basico',
  node_module_ids: [node_module.id],
  description: 'item basico',
  free: true,
  active: true,
  code: 'BAS',
  created_by: User.first.id,
  updated_by: User.first.id,
  item_type: 'video'
)

Medium.create!(
  name: 'Álgebra Linear Vídeo Basico',
  item_ids: [item.id],
  description: 'Explicação do copo que desaparece!',
  medium_type: 'video',
  seconds_duration: 15,
  video_id: 'Vw8R8gCNMoI',
  provider: 'youtube'
)

item_text1 = Item.create!(
  name: 'O que é Álgebra Linear?',
  node_module_ids: [node_module.id],
  description: 'item basico texto',
  free: true,
  active: true,
  code: 'BAS',
  created_by: User.first.id,
  updated_by: User.first.id,
  item_type: 'text'
)

Medium.create!(
  name: 'Texto basico 1 algebra',
  item_ids: [item_text1.id],
  medium_type: 'text',
  medium_text: 'Esta é uma aula em texto'
)

item_exercise1 = Item.create!(
  name: 'Exercicios de Algebra',
  node_module_ids: [node_module.id],
  description: 'item basico exercicio',
  free: true,
  active: true,
  code: 'BAS',
  created_by: User.first.id,
  updated_by: User.first.id,
  item_type: 'fixation_exercise'
)

medium_exercise1 = Medium.create!(
  name: 'Exercício 10',
  item_ids: [item_exercise1.id],
  medium_type: 'fixation_exercise',
  audit_status: 'reviewed',
  medium_text: 'Sample text',
  correction: 'Sample correction',
  answers_attributes: [
    { text: 'alternativa 1', correct: true },
    { text: 'alternativa 2', correct: false },
    { text: 'alternativa 3', correct: false },
    { text: 'alternativa 4', correct: false },
    { text: 'alternativa 5', correct: false }
  ]
)

Medium.create!(
  name: 'Exercício 20',
  item_ids: [item_exercise1.id],
  medium_type: 'fixation_exercise',
  audit_status: 'reviewed',
  medium_text: 'Sample text',
  correction: 'Sample correction',
  answers_attributes: [
    { text: 'alternativa 1', correct: false },
    { text: 'alternativa 2', correct: true },
    { text: 'alternativa 3', correct: false },
    { text: 'alternativa 4', correct: false },
    { text: 'alternativa 5', correct: false }
  ]
)

Medium.create!(
  name: 'Exercício 30',
  item_ids: [item_exercise1.id],
  medium_type: 'fixation_exercise',
  audit_status: 'reviewed',
  medium_text: 'Sample text',
  correction: 'Sample correction',
  answers_attributes: [
    { text: 'alternativa 1', correct: false },
    { text: 'alternativa 2', correct: false },
    { text: 'alternativa 3', correct: true },
    { text: 'alternativa 4', correct: false },
    { text: 'alternativa 5', correct: false }
  ]
)

essay_node = Node.create!(
  name: 'Propostas de Correção de Redação',
  node_type: 'study_plan',
  parent_id: education_segment.id
)

essay_node_child = Node.create!(
  name: 'Linguagens, Códigos e suas Tecnologias',
  node_type: 'area',
  parent_id: essay_node.id,
  color_hex: 'ED4343'
)

essay_style_node = Node.create!(
  name: 'Redação',
  node_type: 'subject',
  parent_id: essay_node_child.id,
  color_hex: 'ED4343'
)

essay_node_module = NodeModule.create!(
  name: 'REDR - Propostas de Redação',
  node_ids: [essay_style_node.id],
  code: 'redr01',
  position: 3
)

essay_item = Item.create!(
  name: 'Propostas de Redação - Vestibulares',
  node_module_ids: [essay_node_module.id],
  description: 'redação tipo texto',
  free: false,
  active: true,
  created_by: Teacher.first.uid,
  updated_by: Teacher.first.uid,
  item_type: 'essay'
)

essay_medium = Medium.create!(
  name: 'Redação básica',
  item_ids: [essay_item.id],
  description: 'A persistência da violência contra a mulher na '\
  'sociedade brasileira!',
  medium_type: 'essay',
  medium_text: 'A persistência da violência contra a mulher na '\
  'sociedade brasileira!'
)

cor_style = CorrectionStyle.create!(name: 'ENEM')

MeSalva::Permalinks::Builder.new(entity_id: education_segment.id,
                                entity_class: 'Node').build_subtree_permalinks

education_segment = Node.find_by_slug('enem-e-vestibulares')

package = Package.create!(id: 100,
                          name: "Enem Semestral",
                          expires_at: "",
                          duration: 6,
                          active: "true",
                          subscription: "false",
                          description: "Descrição do enem semestral",
                          info: ["info 1", "info 2"],
                          max_payments: 1,
                          node_ids: [2, 3],
                          form: 'MuV5ud',
                          listed: true,
                          essay_credits: 10,
                          private_class_credits: 0,
                          unlimited_essay_credits: false,
                          education_segment_slug: education_segment.slug,
                          sales_platforms: ['web'],
                          play_store_product_id: 1,
                          app_store_product_id: 1,
                          prices_attributes:[{ price_type: "bank_slip",
                                               value: 10.00 },
                                               { price_type: 'play_store',
                                                 value: 10.00 }])

access = Access.create(user_id: User.find_by_uid('user@integration.com').id, starts_at: Time.now,
  package_id: package.id, gift: true, expires_at: Time.now + 1.month, active: true,
  )

essay_submission = EssaySubmission.create(
  permalink_id: essay_medium.permalinks.first.id,
  user_id: User.find_by_uid('user@integration.com').id,
  correction_style_id: cor_style.id,
  essay: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJ'\
  'AAAADUlEQVR42mP4z8DwHwAFAAH/VscvDQAAAABJRU5ErkJggg==',
  token: '2m5BgWubSxGWxwXi'
)

essay_submission.update(grades: { grade_1: 10, grade_2: 20, grade_3: 10,
                                  grade_4: 10, grade_5: 10 },
                        appearance: { rotation: 90 })


Item.create(name: 'Basico', slug: "basico", item_type: 'fixation_exercise')

PermalinkEvent.create(
  permalink_slug: "ensino-medio/matematica/algebra-linear/introducao/exercicio",
  permalink_node: ["Ensino Médio", "Matemática"],
  permalink_node_module: "Álgebra Linear",
  permalink_item: "Introdução",
  permalink_medium: nil,
  permalink_node_id: [1, 2],
  permalink_node_module_id: 1,
  permalink_item_id: 1,
  permalink_medium_id: 3,
  permalink_node_type: %w[education_segmentsubject],
  permalink_item_type: "exercise",
  permalink_medium_type: "fixation_exercise",
  permalink_node_slug: ["ensino-medio", "matematica"],
  permalink_node_module_slug: "algebra-linear",
  permalink_item_slug: "introducao",
  permalink_medium_slug: "exercicio-de-fixacao",
  permalink_answer_id: 1,
  permalink_answer_correct: true,
  user_id: 1,
  user_name: nil,
  user_email: nil,
  user_premium: nil,
  user_objective: nil,
  user_objective_id: nil,
  event_name: "prep_test_answer",
  created_at: '02/06/2017 18:44:43',
  location: nil,
  client: nil,
  device: nil,
  user_agent: nil,
  content_rating: nil,
  submission_at: '02/06/2017 18:44:43',
  submission_token: "MjAxNy0wNi0wMiAxODo0NDo0MyArMDAwMA",
  starts_at: '02/06/2017 15:44:43'
)

CanonicalUri.create!(slug: "enem-e-vestibulares/plano-de-estudos-1\
/matematica-e-suas-tecnologias/matematica/trigonometria/o-que-e-um-triangulo\
/video-basico-1")

PermalinkEvent.create!(
  permalink_slug: "enem-e-vestibulares/banco-de-provas/algebra-linear\
/introducao/exercicio10",
  permalink_node: ["Ensino Médio", "Matemática"],
  permalink_node_module: "Álgebra Linear",
  permalink_item: "Introdução",
  permalink_medium: 'Exercício',
  permalink_node_id: [1, 2],
  permalink_node_module_id: 1,
  permalink_item_id: item_exercise1.id,
  permalink_medium_id: medium_exercise1.id,
  permalink_item_type: "exercise",
  permalink_medium_type: "fixation_exercise",
  permalink_node_slug: ["ensino-medio", "matematica"],
  permalink_node_module_slug: "algebra-linear",
  permalink_item_slug: "introducao",
  permalink_medium_slug: "exercicio-de-fixacao",
  permalink_answer_id: 1,
  permalink_answer_correct: true,
  user_id: 1,
  user_name: nil,
  user_email: nil,
  user_premium: nil,
  user_objective: nil,
  user_objective_id: nil,
  event_name: "exercise_answer",
  created_at: '02/06/2017 18:44:43',
  location: nil,
  client: nil,
  device: nil,
  user_agent: nil,
  content_rating: nil,
  submission_at: '02/06/2017 18:44:43',
  submission_token: "MjAxOC0wOS0wNiAxMDozMjozNSAtMDMwMA",
  starts_at: '02/06/2017 15:44:43'
)

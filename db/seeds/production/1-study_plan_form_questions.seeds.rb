# frozen_string_literal: true
sql = 'ALTER SEQUENCE quiz_forms_id_seq RESTART WITH 100000;'
ActiveRecord::Base.connection.execute(sql)
sql = 'ALTER SEQUENCE quiz_questions_id_seq RESTART WITH 100000;'
ActiveRecord::Base.connection.execute(sql)

form = Quiz::Form.create!(
  id: 1,
  name: 'Questionário para plano de estudos ENEM',
  description: 'Preencha para receber seu plano de estudos personalizado!',
  form_type: 'study_plan',
  active: true
)

question1 = Quiz::Question.create!(
  id: 1,
  quiz_form_id: form.id,
  statement: 'Quais dias você pretende estudar?',
  question_type: 'checkbox_table'
)

{ 0 => 'Domingo', 1 => 'Segunda', 2 => 'Terça', 3 => 'Quarta',
  4 => 'Quinta', 5 => 'Sexta', 6 => 'Sábado' }
  .each do |weekday_val, weekday_name|
  { morning: 'Manhã', mid: 'Tarde', evening: 'Noite' }
    .each do |shift_val, shift_name|
    Quiz::Alternative.create!(
      quiz_question_id: question1.id,
      description: "#{weekday_name}|#{shift_name}",
      value: "#{weekday_val}|#{shift_val}"
    )
  end
end

question2 = Quiz::Question.create!(
  id: 2,
  quiz_form_id: form.id,
  statement: 'Quais matérias você quer estudar?',
  question_type:  'checkbox'
)

question3 = Quiz::Question.create!(
  id: 3,
  quiz_form_id: form.id,
  statement: 'Qual o seu perfil de estudo?',
  question_type:  'radio'
)

{
  "Assistir às aulas é suficiente para eu aprender": 1.2,
  "Preciso praticar com exercícios para fixar o conteúdo que estudei": 1.5,
  "Preciso revisar os conteúdos com frequência para não esquecê-los": 1.8,
  "Gosto de resumir e fazer anotações enquanto aprendo": 2,
  "Ainda não achei a melhor forma de estudar, me salva!": 2.25
}.each do |description, value|
  Quiz::Alternative.create!(
    quiz_question_id: question3.id,
    description: description,
    value: value
  )
end

question4 = Quiz::Question.create!(
  id: 4,
  quiz_form_id: form.id,
  statement: 'Quando você irá iniciar seus estudos?',
  question_type: 'text'
)

question5 = Quiz::Question.create!(
  id: 5,
  quiz_form_id: form.id,
  statement: 'Qual a data da sua prova?',
  question_type: 'text'
)

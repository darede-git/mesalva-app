Quiz::Question.update(52, question_type: 'radio')
Quiz::Alternative.create!(
  quiz_question_id: 52,
  description: 'Humanas',
  value: 'chum'
)
Quiz::Alternative.create!(
  quiz_question_id: 52,
  description: 'Linguagens',
  value: 'ling'
)
Quiz::Alternative.create!(
  quiz_question_id: 52,
  description: 'Natureza',
  value: 'cnat'
)
Quiz::Alternative.create!(
  quiz_question_id: 52,
  description: 'Matemática',
  value: 'mat'
)

Quiz::Question.update(53, question_type: 'radio')
Quiz::Alternative.create!(
  quiz_question_id: 53,
  description: 'Rosa',
  value: 'pink'
)
Quiz::Alternative.create!(
  quiz_question_id: 53,
  description: 'Azul',
  value: 'blue'
)
Quiz::Alternative.create!(
  quiz_question_id: 53,
  description: 'Amarelo',
  value: 'yellow'
)
Quiz::Alternative.create!(
  quiz_question_id: 53,
  description: 'Branco',
  value: 'white'
)

question = Quiz::Question.create!(
  id: 110,
  quiz_form_id: 2,
  statement: 'Escolha a língua estrangeira:',
  question_type:  'radio'
)
Quiz::Alternative.create!(
  quiz_question_id: question.id,
  description: 'Inglês',
  value: 'ing'
)
Quiz::Alternative.create!(
  quiz_question_id: question.id,
  description: 'Espanhol',
  value: 'esp'
)

Quiz::Question.create!(
  id: 111,
  quiz_form_id: 2,
  statement: 'Qual o ano da prova?',
  question_type:  'text'
)

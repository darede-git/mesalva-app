form = Quiz::Form.create!(
  id: 4,
  name: 'Lista Sisu',
  description: 'Preencha para receber lista de universidades',
  form_type: 'standard',
  active: true
)

q1 = Quiz::Question.create!(
  id: 101,
  quiz_form_id: form.id,
  statement: "Qual o curso que você deseja? (é só começar a digitar e selecionar o seu curso)",
  question_type: 'select'
)

['ADMINISTRAÇÃO', 'ADMINISTRAÇÃO DE EMPRESAS', 'CIÊNCIAS DE COMPUTAÇÃO'].each_with_index do |description, index|
  Quiz::Alternative.create!(
    quiz_question_id: q1.id,
    description: description,
    value: index)
end

q2 = Quiz::Question.create!(
  id: 102,
  quiz_form_id: form.id,
  statement: "Qual o seu estado?",
  question_type: 'select'
)

['Acre - AC', 'Alagoas - AL', 'Amapá - AP', 'Amazonas - AM', 'Bahia - BA', 'Ceará - CE', 'Distrito Federal - DF', 'Espírito Santo - ES', 'Goiás - GO', 'Maranhão - MA', 'Mato Grosso - MT', 'Mato Grosso do Sul - MS', 'Minas Gerais - MG', 'Pará - PA', 'Paraíba - PB', 'Paraná - PR', 'Pernambuco - PE', 'Piauí - PI', 'Rio de Janeiro - RJ', 'Rio Grande do Norte - RN', 'Rio Grande do Sul - RS', 'Rondônia - RO', 'Roraima - RR', 'Santa Catarina - SC', 'São Paulo - SP', 'Sergipe - SE', 'Tocantins - TO'].each_with_index do |description, index|
  Quiz::Alternative.create!(
    quiz_question_id: q2.id,
    description: description,
    value: index
  )
end

q3 = Quiz::Question.create!(
  id: 103,
  quiz_form_id: form.id,
  statement: "Qual a modalidade de acesso?",
  question_type: 'select'
)

['Ampla Concorrência', 'Candidato Afrodescendente', 'Candidato com deficiência', 'Candidato Egresso da escola pública, carente', 'Candidatos egressos de escola pública'].each_with_index do |description, index|
  Quiz::Alternative.create!(
    quiz_question_id: q3.id,
    description: description,
    value: index
  )
end

Quiz::Question.create!(
  id: 104,
  quiz_form_id: form.id,
  statement: "Nota de Ciências Humanas",
  question_type: 'text'
)

Quiz::Question.create!(
  id: 105,
  quiz_form_id: form.id,
  statement: "Nota de Ciências da Natureza",
  question_type: 'text'
)

Quiz::Question.create!(
  id: 106,
  quiz_form_id: form.id,
  statement: "Nota de Linguagens",
  question_type: 'text'
)


Quiz::Question.create!(
  id: 107,
  quiz_form_id: form.id,
  statement: "Nota de Matemática",
  question_type: 'text'
)


Quiz::Question.create!(
  id: 108,
  quiz_form_id: form.id,
  statement: "Nota de Redação",
  question_type: 'text'
)

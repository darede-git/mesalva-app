# frozen_string_literal: true

FactoryBot.define do
  factory :answer_grid_quiz_form, class: 'Quiz::Form' do
    id 5
    name 'Gabarito ENEM 2017'
    description 'Preencha para receber quantas perguntas você acertou na prova'
    active true
    form_type 'answer_grid'
    initialize_with { Quiz::Form.find_or_create_by(id: id) }
  end

  factory :answer_grid_quiz_form_with_questions,
          parent: :answer_grid_quiz_form do |form|
    form.after :build do |f|
      Array(6..45).each do |id|
        f.questions << FactoryBot
                       .build(:answer_grid_quiz_questions_with_alternatives,
                              form: f, id: id, statement: (id - 5).to_s,
                              question_type: 'radio')
      end
      f.questions << FactoryBot
                     .build(:answer_grid_quiz_question_52_with_alternatives,
                            form: f)
      f.questions << FactoryBot
                     .build(:answer_grid_quiz_question_53_with_alternatives,
                            form: f)
      f.questions << FactoryBot
                     .build(:answer_grid_quiz_question_110_with_alternatives,
                            form: f)
      f.questions << FactoryBot.build(:answer_grid_quiz_question_111, form: f)
    end
  end

  factory :answer_grid_quiz_questions_with_alternatives,
          parent: :quiz_question do |question|
    question.after :build do |q|
      %w[A B C D E].each do |value|
        q.alternatives << FactoryBot.build(:quiz_alternative,
                                           question: q,
                                           description: value,
                                           value: value)
      end
    end
  end

  factory :answer_grid_quiz_question_52_with_alternatives,
          parent: :answer_grid_quiz_question_52 do |question|
    question.after :build do |q|
      {
        'Humanas' => 'chum',
        'Linguagens' => 'ling',
        'Natureza' => 'cnat',
        'Matemática' => 'mat'
      }.each do |description, value|
        q.alternatives << FactoryBot
                          .build(:quiz_alternative,
                                 question: q,
                                 description: description,
                                 value: value)
      end
    end
  end

  factory :answer_grid_quiz_question, class: 'Quiz::Question' do
    association :form, factory: :answer_grid_quiz_form
    sequence :position
    required false
    statement 'Question'
    question_type 'text'

    factory :answer_grid_quiz_question_52 do
      id 52
      initialize_with { Quiz::Question.find_or_create_by(id: id) }
      question_type 'radio'
      statement 'Qual a matéria da sua prova?'
    end

    factory :answer_grid_quiz_question_53 do
      id 53
      initialize_with { Quiz::Question.find_or_create_by(id: id) }
      question_type 'radio'
      statement 'Qual a cor da sua prova?'
    end

    factory :answer_grid_quiz_question_110 do
      id 110
      initialize_with { Quiz::Question.find_or_create_by(id: id) }
      question_type 'radio'
      statement 'Escolha a língua estrangeira:'
    end

    factory :answer_grid_quiz_question_111 do
      id 111
      initialize_with { Quiz::Question.find_or_create_by(id: id) }
      question_type 'text'
      statement 'Qual o ano da prova?'
    end
  end

  factory :answer_grid_quiz_question_53_with_alternatives,
          parent: :answer_grid_quiz_question_53 do |question|
    question.after :build do |q|
      {
        'Rosa' => 'pink',
        'Azul' => 'blue',
        'Amarelo' => 'yellow',
        'Branco' => 'white'
      }.each do |description, value|
        q.alternatives << FactoryBot
                          .build(:quiz_alternative,
                                 question: q,
                                 description: description,
                                 value: value)
      end
    end
  end

  factory :answer_grid_quiz_question_110_with_alternatives,
          parent: :answer_grid_quiz_question_110 do |question|
    question.after :build do |q|
      {
        'Inglês' => 'ing',
        'Espanhol' => 'esp'
      }.each do |description, value|
        q.alternatives << FactoryBot
                          .build(:quiz_alternative,
                                 question: q,
                                 description: description,
                                 value: value)
      end
    end
  end

  factory :answer_grid_quiz_form_submission, class: 'Quiz::FormSubmission' do
    association :form, factory: :answer_grid_quiz_form
  end

  factory :answer_grid_quiz_form_submission_with_answers,
          parent: :answer_grid_quiz_form_submission do |form_submission|
    association :user, factory: :user
    form_submission.after :build do |fs|
      [6, 52, 53, 110, 111].each do |question_id|
        fs.answers << FactoryBot
                      .build(:"answer_grid_quiz_answer_#{question_id}",
                             form_submission: fs)
      end
    end
  end

  factory :answer_grid_quiz_answer, class: 'Quiz::Answer' do
    factory :answer_grid_quiz_answer_6 do
      association :question,
                  factory: :answer_grid_quiz_questions_with_alternatives, id: 6
      alternative { Quiz::Alternative.by_question_id(6).first }
    end

    factory :answer_grid_quiz_answer_52 do
      association :question,
                  factory: :answer_grid_quiz_question_52_with_alternatives
      alternative { Quiz::Alternative.by_question_id(52).second }
    end

    factory :answer_grid_quiz_answer_53 do
      association :question,
                  factory: :answer_grid_quiz_question_53_with_alternatives
      alternative { Quiz::Alternative.by_question_id(53).first }
    end

    factory :answer_grid_quiz_answer_110 do
      association :question,
                  factory: :answer_grid_quiz_question_110_with_alternatives
      alternative { Quiz::Alternative.by_question_id(110).first }
    end

    factory :answer_grid_quiz_answer_111 do
      association :question, factory: :answer_grid_quiz_question_111
      value { 2018 }
    end
  end
end

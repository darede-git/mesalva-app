# frozen_string_literal: true

FactoryBot.define do
  factory :study_plan_quiz_form, class: 'Quiz::Form' do
    id 1
    name 'Plano de estudos'
    description 'Plano de estudos'
    active true
    form_type 'study_plan'
    initialize_with { Quiz::Form.find_or_create_by(id: id) }
  end

  factory :study_plan_quiz_form_with_questions,
          parent: :study_plan_quiz_form do |form|
    form.after :build do |f|
      f.questions << FactoryBot
                     .build(:study_plan_quiz_question_1_with_alternatives,
                            form: f)
      f.questions << FactoryBot
                     .build(:study_plan_quiz_answer_2_with_nodes, form: f)
      f.questions << FactoryBot
                     .build(:study_plan_quiz_question_3_with_alternatives,
                            form: f)
      [4, 5].each do |question_id|
        f.questions << FactoryBot
                       .build(:"study_plan_quiz_question_#{question_id}",
                              form: f)
      end
      f.questions << FactoryBot
                     .build(:study_plan_quiz_question_109_with_alternatives,
                            form: f)
    end
  end

  factory :study_plan_quiz_alternative, class: 'Quiz::Alternative' do
    sequence(:description) { |n| "quiz alternative #{n}" }
    sequence(:value) { |n| "quiz_alt_val#{n}" }
  end

  factory :study_plan_quiz_form_submission, class: 'Quiz::FormSubmission' do
    association :form, factory: :study_plan_quiz_form
  end

  factory :study_plan_quiz_form_submission_with_answers,
          parent: :study_plan_quiz_form_submission do |form_submission|
    association :user, factory: :user
    form_submission.after :build do |fs|
      [1, 3, 4, 5, 109].each do |question_id|
        fs.answers << FactoryBot
                      .build(:"study_plan_quiz_answer_#{question_id}",
                             form_submission: fs)
      end
      fs.answers << FactoryBot
                    .build(:study_plan_quiz_answer_2_with_nodes,
                           form_submission: fs)
    end
  end

  factory :study_plan_quiz_question_1_with_alternatives,
          parent: :study_plan_quiz_question_1 do |question|
    question.after :build do |q|
      { 0 => 'Domingo', 1 => 'Segunda', 2 => 'Terça', 3 => 'Quarta',
        4 => 'Quinta', 5 => 'Sexta', 6 => 'Sábado' }
        .each do |weekday_val, weekday_name|
        { morning: 'Manhã', mid: 'Tarde', evening: 'Noite' }
          .each do |shift_val, shift_name|
          q.alternatives << FactoryBot
                            .build(:study_plan_quiz_alternative,
                                   question: q,
                                   description: "#{weekday_name}|#{shift_name}",
                                   value: "#{weekday_val}|#{shift_val}")
        end
      end
    end
  end

  factory :study_plan_quiz_question_109_with_alternatives,
          parent: :study_plan_quiz_question_109 do |question|
    question.after :build do |q|
      {
        'true' => 'Recalcular: Repriorizar os módulos que ainda não estudei '\
                  'e manter os que estudei como concluídos.',
        'false' => 'Criar um novo: Quero recomeçar a estudar do início.'
      }.each do |value, description|
        q.alternatives << FactoryBot
                          .build(:study_plan_quiz_alternative,
                                 question: q,
                                 description: description,
                                 value: value)
      end
    end
  end

  factory :study_plan_quiz_question_3_with_alternatives,
          parent: :study_plan_quiz_question_3 do |question|
    question.after :build do |q|
      q.alternatives << \
        FactoryBot
        .build(:study_plan_quiz_alternative,
               question: q,
               description: 'Assistir às aulas é suficiente para eu aprender',
               value: 1.2)
    end
  end

  factory :study_plan_quiz_answer_2_with_nodes,
          parent: :study_plan_quiz_answer_2 do |_answer|
    value { create(:node_subject, color_hex: 'ffffff').id }
  end

  factory :study_plan_quiz_question, class: 'Quiz::Question' do
    association :form, factory: :study_plan_quiz_form
    sequence :position
    required false
    statement 'Question'
    question_type 'text'

    factory :study_plan_quiz_question_1 do
      id 1
      initialize_with { Quiz::Question.find_or_create_by(id: id) }
      question_type 'checkbox_table'
      statement 'Quais dias você pretende estudar?'
    end

    factory :study_plan_quiz_question_2 do
      id 2
      initialize_with { Quiz::Question.find_or_create_by(id: id) }
      question_type 'checkbox'
      statement 'Quais matérias você quer estudar?'
    end

    factory :study_plan_quiz_question_3 do
      id 3
      initialize_with { Quiz::Question.find_or_create_by(id: id) }
      question_type 'radio'
      statement 'Qual o seu perfil de estudo?'
    end

    factory :study_plan_quiz_question_4 do
      id 4
      initialize_with { Quiz::Question.find_or_create_by(id: id) }
      question_type 'text'
      statement 'Quando você irá iniciar seus estudos?'
    end

    factory :study_plan_quiz_question_5 do
      id 5
      initialize_with { Quiz::Question.find_or_create_by(id: id) }
      question_type 'text'
      statement 'Qual a data da sua prova?'
    end

    factory :study_plan_quiz_question_109 do
      id 109
      initialize_with { Quiz::Question.find_or_create_by(id: id) }
      question_type 'checkbox'
      statement 'Você quer recalcular seu plano de estudos ou criar um novo?'
    end
  end

  factory :study_plan_quiz_answer, class: 'Quiz::Answer' do
    factory :study_plan_quiz_answer_1 do
      association :question,
                  factory: :study_plan_quiz_question_1_with_alternatives
      alternative { Quiz::Alternative.by_question_id(1).first }
    end

    factory :study_plan_quiz_answer_2 do
      association :question, factory: :study_plan_quiz_question_2
    end

    factory :study_plan_quiz_answer_3 do
      association :question,
                  factory: :study_plan_quiz_question_3_with_alternatives
      alternative { Quiz::Alternative.by_question_id(3).first }
    end

    factory :study_plan_quiz_answer_4 do
      association :question, factory: :study_plan_quiz_question_4
      value Date.today.strftime("%Y-%m-%d")
    end

    factory :study_plan_quiz_answer_5 do
      association :question, factory: :study_plan_quiz_question_5
      value { "enem|#{(Date.today + 1.month).strftime('%Y-%m-%d')}" }
    end

    factory :study_plan_quiz_answer_109 do
      association :question,
                  factory: :study_plan_quiz_question_109_with_alternatives
      alternative { Quiz::Alternative.by_question_id(109).last }
    end
  end
end

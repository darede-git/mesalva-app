# frozen_string_literal: true

class StudyPlanRecalcQuestion < ActiveRecord::Migration[4.2]
  def change
    if Quiz::Form.exists?(1)
      Quiz::Question.create!(
        id: 109,
        quiz_form_id: 1,
        statement: 'Você quer recalcular seu plano de estudos ou criar um novo?',
        question_type: 'radio'
      )

      Quiz::Alternative.create!(
        quiz_question_id: 109,
        description: 'Recalcular: Repriorizar os módulos que ainda não estudei '\
        'e manter os que estudei como concluídos.',
        value: 'true'
      )

      Quiz::Alternative.create!(
        quiz_question_id: 109,
        description: 'Criar um novo: Quero recomeçar a estudar do início.',
        value: 'false'
      )
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SisuQueCursoLeadsWorker do
  context 'perform' do
    before do
      ENV['QUIZ_FORM_STUDY_PLAN_IDS'] = "[100]"
      ENV['SISU_QUECURSO_LEADS_WORKER_ACTIVE'] = "true"
      ENV['SISU_QUECURSO_LEADS_START_DATE'] = Date.today.to_s
      ENV['SISU_QUECURSO_LEADS_END_DATE'] = Date.tomorrow.to_s
    end
    let(:form) do
      create(:quiz_form_with_questions, id: 1000, name: 'Lista Sisu')
    end

    let(:user) do
      create(:user_with_address_attributes,
             birth_date: Date.today.to_s,
             phone_number: "12345")
    end

    let(:user_no_phone_number) do
      create(:user_with_address_attributes,
             birth_date: Date.today.to_s,
             phone_number: "")
    end

    let!(:quiz_form_submission) do
      create(:quiz_form_submission_with_answers,
             form: form, user: user)
    end

    let!(:second_quiz_form_submission) do
      create(:quiz_form_submission_with_answers,
             form: form, user: user_no_phone_number)
    end

    it 'saves leads to S3' do
      expect(MeSalva::Aws::File).to receive(:write).and_return(true)

      create(:quiz_question_with_alternative, id: 101)
      create(:quiz_question_with_alternative, id: 102)

      create(:quiz_answer,
             form_submission: quiz_form_submission,
             quiz_question_id: 101)
      create(:quiz_answer,
             form_submission: quiz_form_submission,
             quiz_question_id: 102)

      create(:crm_event, id: 9_000_000,
                         event_name: 'campaign_view',
                         campaign_view_name: 'quecurso',
                         user_id: user_no_phone_number.id)

      create(:quiz_answer,
             form_submission: second_quiz_form_submission,
             quiz_question_id: 101)
      create(:quiz_answer,
             form_submission: second_quiz_form_submission,
             quiz_question_id: 102)

      subject.perform
    end
  end
end

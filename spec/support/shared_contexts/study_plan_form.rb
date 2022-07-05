# frozen_string_literal: true

RSpec.shared_context "study plan form" do
  let!(:form) do
    form_submission.form
  end
  let(:question1) { form.questions.find(1) }
  let(:question2) { form.questions.find(2) }
  let(:question3) { form.questions.find(3) }
  let(:question4) { form.questions.find(4) }
  let(:question5) { form.questions.find(5) }
  let(:question109) { form.questions.find(109) }
  let(:alternative) { question1.alternatives.first }
  let(:form_submission) do
    create(:study_plan_quiz_form_submission_with_answers, user: user)
  end
end

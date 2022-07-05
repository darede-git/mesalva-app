# frozen_string_literal: true

class CreateSisuScoreWorker
  include Sidekiq::Worker

  def perform(form_submission_id, user_id, attributes)
    attributes.each do |h|
      h.delete('approval_prospect')
      h.delete('modalities')
    end

    SisuScore.create!(attributes) do |score|
      score.quiz_form_submission_id = form_submission_id
      score.user_id = user_id
    end
  end
end

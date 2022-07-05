# frozen_string_literal: true

class EssaySubmissionTransition < ActiveRecord::Base
  include Statesman::Adapters::ActiveRecordTransition

  belongs_to :essay_submission, inverse_of: :essay_submission_transitions

  after_destroy :update_most_recent, if: :most_recent?

  private

  def update_most_recent
    last_transition = essay_submission.essay_submission_transitions
                                      .order(:sort_key).last
    return unless last_transition.present?

    last_transition.update_column(:most_recent, true)
  end
end

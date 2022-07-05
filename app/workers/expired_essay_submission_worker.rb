# frozen_string_literal: true

require 'me_salva/signature/order'

class ExpiredEssaySubmissionWorker < BaseSignaturesWorker
  def perform
    EssaySubmission.expired_correcting.each do |essay|
      essay.state_machine.transition_to!(:awaiting_correction)
    end
  end
end

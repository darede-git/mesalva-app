# frozen_string_literal: true

class PendingEssayEventWorker
  include Sidekiq::Worker

  def perform
    EssaySubmission.by_status(:pending).each do |essay|
      next unless created_the_day_before?(essay)

      Notification.new(
        user_id: essay.user_id,
        notification_type: "essay_draft_created_but_not_sent"
      ).save
    end
  end

  private

  def created_the_day_before?(essay)
    essay.created_at.to_date == yesterday
  end

  def yesterday
    (Time.now - 1.day).to_date
  end
end

# frozen_string_literal: true

class EssayEvent < ActiveRecord::Base
  validates :event_name,
            :user_id,
            :user_uid,
            :correction_style,
            :permalink,
            :essay_status,
            :essay_submission,
            presence: true, allow_blank: false
  belongs_to :essay_submission
  belongs_to :user
end

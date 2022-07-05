# frozen_string_literal: true

class Notification < ActiveRecord::Base
  belongs_to :user
  has_many :notification_events
  default_scope { order(created_at: :desc) }

  validates :notification_type, inclusion: {
    in: %w[essay_draft_created_but_not_sent
           bookshop_coupon_pending
           bookshop_coupon_available
           back_to_classes_campaign]
  }

  scope :by_id, lambda { |user, id|
    where(user: user).where(id: id)
  }

  scope :by_user, lambda { |user|
    where(user: [user, global_user])
      .where('expires_at >= ? OR expires_at IS NULL', Time.now)
  }

  scope :all_by_user, lambda { |user|
    where(user: [user, global_user])
  }

  def self.global_user
    nil
  end
end

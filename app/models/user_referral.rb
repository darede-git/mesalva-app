# frozen_string_literal: true

class UserReferral < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user_id
  validates_uniqueness_of :user_id

  scope :processed, -> { where(being_processed: false) }

  def user_token
    user.token
  end
end

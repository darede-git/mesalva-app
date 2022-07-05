# frozen_string_literal: true

class Form < ActiveRecord::Base
  validates :user_uid, :metadata, :token, :completed,
            presence: true, allow_blank: false
end

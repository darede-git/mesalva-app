# frozen_string_literal: true

class PrepTestScore < ActiveRecord::Base
  belongs_to :user
  belongs_to :prep_test

  validates :submission_token,
            :user,
            :score,
            :permalink_slug, presence: true, allow_blank: false
end

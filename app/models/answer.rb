# frozen_string_literal: true

class Answer < ActiveRecord::Base
  belongs_to :medium

  validates :text, presence: true, allow_blank: false
end

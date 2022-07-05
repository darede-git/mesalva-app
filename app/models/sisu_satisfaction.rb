# frozen_string_literal: true

class SisuSatisfaction < ActiveRecord::Base
  belongs_to :user

  validates  :user, presence: true
end

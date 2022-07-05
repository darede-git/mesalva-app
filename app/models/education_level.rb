# frozen_string_literal: true

class EducationLevel < ActiveRecord::Base
  has_many :users
  has_many :packages
  validates :name, presence: true, allow_blank: false
end

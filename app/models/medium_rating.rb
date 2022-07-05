# frozen_string_literal: true

class MediumRating < ActiveRecord::Base
  belongs_to :medium
  belongs_to :user

  validates_numericality_of :value, greater_than: 0, less_than_or_equal_to: 5
end

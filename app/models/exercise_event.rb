# frozen_string_literal: true

class ExerciseEvent < ActiveRecord::Base
  belongs_to :user
end

# frozen_string_literal: true

class InstructorUser < ActiveRecord::Base
  belongs_to :instructor
  belongs_to :user

  validates_presence_of :instructor_id, :user_id
end

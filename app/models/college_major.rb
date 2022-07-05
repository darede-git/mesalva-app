# frozen_string_literal: true

class CollegeMajor < ActiveRecord::Base
  belongs_to :college
  belongs_to :major

  validates :college, :major, presence: true
end

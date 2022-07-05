# frozen_string_literal: true

class Faq < ActiveRecord::Base
  include TokenHelper

  before_validation :generate_token, on: :create

  has_many :questions, dependent: :destroy
  validates :name, presence: true
end

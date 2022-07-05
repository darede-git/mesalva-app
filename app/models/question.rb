# frozen_string_literal: true

class Question < ActiveRecord::Base
  include TokenHelper

  before_validation :generate_token, on: :create

  mount_base64_uploader :image, ImageUploader
  belongs_to :faq
  validates :title, presence: true
  validates :answer, presence: true
  validates :token, presence: true, uniqueness: true
end

# frozen_string_literal: true

class Testimonial < ActiveRecord::Base
  include TokenHelper

  before_validation :generate_token, on: :create

  mount_base64_uploader :avatar, ImageUploader
  validates :text, :education_segment_slug, presence: true
  validates :token, presence: true, uniqueness: true
end

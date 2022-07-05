# frozen_string_literal: true

class ContentTeacher < ActiveRecord::Base
  include SlugHelper
  include CommonModelScopes

  has_many :content_teacher_items
  has_many :items, through: :content_teacher_items
  has_many :mentoring

  mount_base64_uploader :image, ContentTeacherImageUploader
  mount_base64_uploader :avatar, ContentTeacherImageUploader

  scope :active, -> { where(active: true) }
end

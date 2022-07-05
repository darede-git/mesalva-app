# frozen_string_literal: true

class Image < ActiveRecord::Base
  validates :image, presence: true, allow_blank: false
  belongs_to :platform
  mount_base64_uploader :image, ImageUploader
end

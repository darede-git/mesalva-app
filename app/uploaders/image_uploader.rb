# frozen_string_literal: true

class ImageUploader < BaseImageUploader
  def name
    return 'integration' if Rails.env.test?

    Base64.encode64("#{Time.now}#{Time.now.usec}")
  end

  def extension_whitelist
    %w[jpg jpeg png svg gif]
  end

  def store_dir
    'uploads/image'
  end
end

# frozen_string_literal: true

class BaseImageUploader < CarrierWave::Uploader::Base
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}"
  end

  def extension_whitelist
    %w[jpg jpeg png gif zip]
  end

  def filename
    return nil if original_filename.nil?

    ext = original_filename.split('.').last
    "#{name}.#{ext}"
  end

  def name(uid = model.slug)
    return 'integration' if Rails.env.test?

    @name ||= Base64.encode64(uid + update_time).delete("\n")
  end

  def update_time
    return model.updated_at.strftime('%d%m%YT%H%M') if model.updated_at

    Time.now.strftime('%d%m%YT%H%M')
  end
end

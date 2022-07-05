# frozen_string_literal: true

class AttachmentUploader < BaseImageUploader
  def store_dir
    return "uploads/#{model.class.to_s.underscore}/#{mounted_as}" if model.platform_id.nil?

    platform = Platform.find(model.platform_id)
    "uploads/platforms/#{platform.slug}/#{model.class.to_s.underscore}/#{mounted_as}"
  end

  def extension_whitelist
    %w[jpg jpeg png gif zip pdf]
  end

  def default_url
    return "cdnqa.mesalva/#{store_dir}name.zip" if Rails.env.test?
  end
end

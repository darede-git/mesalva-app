# frozen_string_literal: true

class MemberImageUploader < BaseImageUploader
  include CarrierWave::MiniMagick

  def name
    super(model.uid)
  end

  def extension_whitelist
    %w[jpg jpeg png]
  end

  process resize_to_fill: [260, 260]
end

# frozen_string_literal: true

class OrderImageUploader < BaseImageUploader
  def name
    super(model.token)
  end
end

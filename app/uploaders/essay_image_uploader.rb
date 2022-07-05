# frozen_string_literal: true

class EssayImageUploader < BaseImageUploader
  def name
    super(model.user.uid)
  end
end

# frozen_string_literal: true

module DesignSystem
  class Video < ComponentBase
    COMPONENT_NAME = 'Video'
    FIELDS = {
      provider: %i[sambatech youtube vimeo],
      video_id: :string
    }

    def self.from_medium(medium)
      self.render(provider: medium.provider, video_id: medium.video_id)
    end
  end
end

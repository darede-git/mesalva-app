# frozen_string_literal: true

require 'samba_videos'
require 'samba_videos/category'
require 'samba_videos/media'

module MeSalva
  class Videos
    def initialize(offset = nil, limit = nil)
      @limit = limit || ENV['FINDERS_LIMIT']
      @offset = offset || ENV['FINDERS_OFFSET']
    end

    def categories
      find_all_categories
    end

    def medias(category_id)
      find_all_medias(category_id)
    end

    private

    def find_all_categories
      SambaVideos::Category.find(:all, params: { pid: project_id,
                                                 access_token: access_token,
                                                 limit: @limit,
                                                 start: @offset })
    end

    def find_all_medias(category_id)
      SambaVideos::Media.find(:all, params: { categoryId: category_id,
                                              types: 'VIDEO',
                                              pid: project_id,
                                              access_token: access_token,
                                              limit: @limit,
                                              start: @offset })
    end

    def access_token
      ENV['SAMBA_ACCESS_TOKEN']
    end

    def project_id
      ENV['SAMBA_PROJECT_ID']
    end
  end
end

# frozen_string_literal: true

module Bff
  module Contents
    module Sections
      class ContentSectionDefaultAdapter < ContentSectionAdapterBase
        def initialize(content, **attr)
          @content = content
          @title = "Lista de conteúdos"
        end

        def load_content_list
          @list = @content.active_children.map do |child|
            {
              "icon": { "name": "checkmark-circle", "color": "var(--color-neutral-500)" },
              "title": child.name,
              "permalink": child.main_permalink.slug,
              "link": { "href": "/app/conteudos/#{child.token}" }
            }
          end
        end
      end
    end
  end
end

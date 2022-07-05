# frozen_string_literal: true

module Bff
  module Contents
    module Sections
      class ContentSectionChapterAdapter < ContentSectionAdapterBase
        def initialize(content, **attr)
          @content = content
          @title = "Lista de módulos"
          @filter_label = "Filtrar módulo pelo nome ou código"
        end

        def load_content_list
          @list = @content.active_children.map do |child|
            {
              "icon": { "name": "checkmark-circle", "color": "var(--color-neutral-500)" },
              "title": module_name(child.name),
              "link": { "href": "/app/conteudos/#{child.token}" },
              "permalink": child.main_permalink&.slug,
              "labels": [
                { "children": module_code(child.name), "theme": 'ghost', "variant": 'primary' }
              ]
            }
          end
        end

        private

        def module_name(name)
          name.gsub(/^\w+ - /, '')
        end

        def module_code(name)
          name.gsub(/^(\w+) - .*/, '\1')
        end
      end
    end
  end
end

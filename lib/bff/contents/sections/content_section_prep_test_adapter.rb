# frozen_string_literal: true

module Bff
  module Contents
    module Sections
      class ContentSectionPrepTestAdapter < ContentSectionAdapterBase
        def initialize(content, **attr)
          @content = content
          @title = "Lista de provas"
        end

        def load_content_list
          @modules = @content.active_children
          @list = @modules.map do |child|
            {
              "icon": { "name": "checkmark-circle", "color": "var(--color-neutral-500)" },
              "title": module_name(child.name),
              "link": { "href": "/app/conteudos/#{child.token}" },
              "permalink": child.main_permalink&.slug,
              "labels": labels(child)
            }
          end
        end

        def sections
          highlight = @modules.first
          [
            { "component": "SectionTitle", "title": @content.name },
            {
              "component": "SectionCard",
              "children": [
                {
                  "component": "Slide",
                  "color": "var(--color-white)",
                  "backgroundColor": "var(--color-primary-500)",
                  "overline": "SIMULADÃO | TRI",
                  "title": highlight.name,
                  "backgroundImage": {
                    "src": ""
                  },
                  "buttons": [
                    {
                      "children": "Ver simuladão",
                      "variant": "text",
                      "size": "sm",
                      "href": "https://www.mesalva.com/#{highlight.main_permalink&.slug}"
                    }
                  ]
                }
              ]
            },
            {
              "component": "SectionCard",
              "title": title,
              "children": [
                {
                  "component": "ComponentList",
                  "filterLabel": "Filtrar prova",
                  "list": list
                }
              ]
            }
          ]
        end

        private

        def labels(child)
          if child.name.match(/Simuladão/)
            return [
              { "children": "Simuladão", "theme": 'ghost', "variant": 'primary' },
              { "children": "TRI", "theme": 'ghost', "variant": 'info' }
            ]
          end
          if child.name.match(/Simuladinho/)
            return [
              { "children": "Simuladinho", "theme": 'ghost', "variant": 'warning' }
            ]
          end
          []
        end

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

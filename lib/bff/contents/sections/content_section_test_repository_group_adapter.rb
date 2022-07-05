# frozen_string_literal: true

module Bff
  module Contents
    module Sections
      class ContentSectionTestRepositoryGroupAdapter < ContentSectionAdapterBase
        IMAGES = {
          ENEM: "https://cdn.mesalva.com/uploads/image/MjAyMi0wNC0yOSAxNzoyMTo0NSArMDAwMDIyNDMyOQ%3D%3D%0A.svg",
          UFRGS: "https://cdn.mesalva.com/uploads/image/MjAyMi0wNC0yOSAxOToxNzoyOSArMDAwMDQ3ODIyMw%3D%3D%0A.svg"
        }.freeze

        def initialize(content, **attr)
          @content = content
          @title = "Lista de conteúdos"
        end

        def load_content_list
          @list = @content.active_children.map do |child|
            image = IMAGES[child.name.to_sym]
            {
              "component": "ItemButton",
              "image": image,
              "icon_name": image ? nil : 'exercicio',
              "title": child.name,
              "permalink": child.main_permalink.slug,
              "link": { "href": "/app/conteudos/#{child.token}" }
            }
          end
        end

        def sections
          [
            {
              "component": "SectionTitle",
              "title": "Banco de provas",
              "children": [
                {
                  "component": "InfoButton",
                  "title": "Informações",
                  "children": [
                    {
                      "component": "div",
                      "children": [
                        {
                          "component": "Text",
                          "size": "sm",
                          "html": "Em construção..."
                        }
                      ]
                    }
                  ]
                }
              ]
            },
            {
              "component": "SectionCard",
              "title": "Provas",
              "children": [
                {
                  "component": "Grid",
                  "columns": {
                    "sm": 4
                  },
                  "children": list
                }
              ]
            }
          ]
        end
      end
    end
  end
end

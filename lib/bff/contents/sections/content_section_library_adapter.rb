# frozen_string_literal: true

module Bff
  module Contents
    module Sections
      class ContentSectionLibraryAdapter < ContentSectionAdapterBase
        def initialize(content, **attr)
          @content = content
          @title = "Todas as Matérias"
        end

        def only_list
          @old_contents = true
          load_content_list
        end

        def load_content_list
          @sections_children = []
          @list = @content.active_children.map do |materia|
            children = parse_grand_children(materia)
            @sections_children << {
              "component": "Subtitle",
              "children": materia.name,
              "className": "mb-sm mt-xl color-text-secondary"
            }
            @sections_children << {
              "component": "Grid",
              "columns": { "sm": 4, "md": 5 },
              "children": children
            }
            {
              name: materia.name,
              children: children
            }
          end
        end

        def sections
          [
            {
              "component": "SectionTitle",
              "title": "Matérias",
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
                          "html": "<b>Saiba o que estudar para o ENEM com a lista completa de conteúdos de todas as matérias da prova.</b>"
                        },
                        {
                          "component": "Text",
                          "size": "sm",
                          "html": "Encontre o que você precisa estudar por matéria. Organizamos os conteúdos em capítulos e módulos de aproximadamente uma hora com aulas em vídeo intercaladas com exercícios e resumos em pdf para download."
                        }
                      ]
                    }
                  ]
                }
              ]
            },
            {
              "component": "SectionCard",
              "title": @title,
              "children": @sections_children
            }
          ]
        end

        private

        def parse_grand_children(child)
          parse_child_color = ContentSubject.simplified_slug(child.slug)
          @grand_children = child.active_children.map do |grand_child|
            icon_name = ContentSubject.simplified_slug(grand_child.slug)
            icon_color = "var(--color-#{parse_child_color}-500)"
            title = ContentSubject.simplified_name(grand_child.name)
            permalink = "enem-e-vestibulares/materias/#{child.slug}/#{grand_child.slug}"
            href = @old_contents ? "https://www.mesalva.com/#{permalink}" : "/app/conteudos/#{grand_child.token}"
            {
              component: "ItemButton",
              icon_name: icon_name,
              icon_color: icon_color,
              title: title,
              token: grand_child.token,
              href: href,
              permalink: permalink
            }
          end
        end
      end
    end
  end
end

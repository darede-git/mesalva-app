# frozen_string_literal: true

module Bff
  module Contents
    module Sections
      class ContentSectionAreaSubjectAdapter < ContentSectionAdapterBase
        def initialize(content, **attr)
          @content = content
          @title = "Lista de conteúdos"
        end

        def load_content_list
          @list = []
          @content.active_children.each do |child|
            child.active_children.each do |grand_children|
              @list << {
                "icon": { "name": "checkmark-circle", "color": "var(--color-neutral-500)" },
                "title": grand_children.name,
                "permalink": grand_children.main_permalink.slug,
                "link": { "href": "/app/conteudos/#{grand_children.token}" },
                "labels": [area_subject_label_by_name(child.name)]
              }
            end
          end
        end

        private

        def area_subject_label_by_name(label_name)
          if label_name == 'Medicina'
            return { "children": 'Medicina', "theme": "subject", "variant": "medicina" }
          end

          colors = { "Revisão" => "primary", "Especial" => "warning" }
          {
            "children": label_name,
            "theme": 'ghost',
            "variant": colors[label_name] || "info"
          }
        end
      end
    end
  end
end

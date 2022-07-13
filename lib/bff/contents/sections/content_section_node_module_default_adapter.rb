# frozen_string_literal: true

module Bff
  module Contents
    module Sections
      class ContentSectionNodeModuleDefaultAdapter < ConsoleTemplateBase
        def initialize(content, **attr)
          @content = content
          @page_component = 'ConsoleTemplate'
          @title = "Lista de aulas"
          @description = @content.description
        end

        def load_content_list
          set_items_list
          @list = @content.active_children.map do |child|
            {
              component: "ItemButton",
              icon_name: 'natureza',
              icon_color: "var(--color-natureza-500)",
              title: module_name(child.name),
              href: "/app/conteudos/#{child.token}"
            }
          end
        end

        def sections
          [
            DesignSystem::Breadcrumb.content_go_back(@content.parents.first&.token),
            DesignSystem::Grid.render(children: [
              DesignSystem::Text.render(html: @content.description || 'Módulo sem descrição')
            ])
          ]
        end

        def items_list
          @content.active_children.map do |item|
            ItemsListElement.new(item, context: @content.token).render
          end
        end

        def render(entity_type)
          # right_content_route = ItemsListElement.new(@content).content_route
          # return redirect_to_type(right_content_route) unless right_content_route == entity_type
          load_content_list
          {
            component: 'ConsoleTemplate',
            title: "#{@content.name} | Me Salva!",
            description: @description,
            image: @image,
            content: {
              title: module_name(@content.name),
              children: sections,
            },
            sidebar: {
              list: items_list
            }
          }
        end

        def item_subtitle(item)
          return video_seconds_duration_label(item) if item.item_type == 'video'
          if item.item_type == 'fixation_exercise'
            return "#{item.media.where(medium_type: 'fixation_exercise').count} exercícios"
          end

          nil
        end

        def video_seconds_duration_label(item)
          seconds_duration = item.media.where(medium_type: 'video').first.seconds_duration
          return nil if seconds_duration.blank? || seconds_duration.zero?

          minutes_duration = (seconds_duration / 60.0).round
          "#{minutes_duration} minutos"
        end

        def item_icon(item)
          return 'video' if item.item_type == 'video'
          return 'file-text' if %w[text essay].include?(item.item_type)

          'edit'
        end

        def set_items_list
          @items_list = @content.active_children.map do |item|
            ItemsListElement.new(item, context: @content.token).render
          end
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

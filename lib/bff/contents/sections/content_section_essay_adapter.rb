# frozen_string_literal: true

module Bff
  module Contents
    module Sections
      class ContentSectionEssayAdapter < ContentSectionAdapterBase
        def initialize(content, **attr)
          @content = content
          @page_component = 'ConsoleTemplate'
          @context = attr[:context]
          @description = medium.medium_text[0..160]
          @title = @content.name
        end

        def load_content_list
          set_items_list
          @list = @content.active_children.map do |child|
            {
              "icon": { "name": "checkmark-circle", "color": "var(--color-neutral-500)" },
              "title": child.name,
              "permalink": child.main_permalink.slug,
              "link": { "href": "/app/conteudos/#{child.token}" }
            }
          end
        end

        def sections
          [
            DesignSystem::Breadcrumb.content_go_back(@context || @content.parents.first.token),
            DesignSystem::Grid.render("controller": "getBffApi",
                                      "endpoint": "user/contents/essay/#{medium.token}"),
            DesignSystem::Divider.render
          ]
        end

        private

        def action_buttons_section
          DesignSystem::Grid.render(columns: 2,
                                    "controller": "getBffApi",
                                    "endpoint": "user/contents/essay/#{medium.token}")
        end

        def context_parent
          return @content.parents.first if @context.nil?

          NodeModule.find_by_token(@context)
        end

        def set_items_list
          node_module = context_parent
          @items_list = node_module.active_children.map do |item|
            ItemsListElement.new(item, active: item.token == @content.token, context: @context).render
          end
        end

        def rating_section
          DesignSystem::Div.render(
            class_name: 'flex justify-content-end align-items-center gap-sm',
            children: [
              DesignSystem::Text.render(children: 'Avalie Esta aula:'),
              DesignSystem::RatingStar.new(max_value: 5).use_endpoint("user/contents/rating/#{medium.token}").to_h
            ]
          )
        end

        def medium
          @medium ||= @content.media.first
        end

        def medium_text
          medium.medium_text
        end
      end
    end
  end
end

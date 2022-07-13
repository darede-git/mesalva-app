# frozen_string_literal: true

module Bff
  module Contents
    module Sections
      class ContentSectionExerciseItemAdapter < ConsoleTemplateBase
        EXERCISE_LETTERS = %w[A B C D E]

        def initialize(content, **attr)
          @content = content
          @page_component = 'ConsoleTemplate'
          @title = @content.parents.first&.name
          set_context(attr[:context])
          set_parent_item
          set_parent_module
        end

        def render(entity_type)
          # right_content_route = ItemsListElement.new(@content).content_route
          # return redirect_to_type(right_content_route) unless right_content_route == entity_type
          set_exercise_number
          {
            component: 'ConsoleTemplate',
            title: "#{@content.name} | Me Salva!",
            description: @description,
            image: @image,
            breadcrumb: DesignSystem::Breadcrumb.content_go_back_simple(@context),
            content: {
              difficulty: @content.difficulty,
              title: exercise_title,
              event_slug: "exercises/#{@content.token}?item_token=#{@current_item&.token}&node_module_token=#{@context}",
              rating_slug: "rating/#{@content.token}?context=#{@context}/#{@current_item&.token}",
              report_href: report_href,
              children: [exercise_list],
            },
            sidebar: {
              event_slug: "sidebar_events/#{@content.token}?item_token=#{@current_item&.token}&node_module_token=#{@context}",
              list: items_list
            }
          }
        end

        def exercise_title
          "Questão #{@number.to_s.rjust(2, '0')}"
        end

        def report_href
          typeform_url = "https://www.mesalva.com/redirects/typeform/yaUQOR8c"
          "#{typeform_url}?permalink=#{@content.main_permalink&.slug}&token=#{@content.token}"
        end

        def exercise_list
          DesignSystem::ExerciseList.render(event_slug: "exercises/#{@content.token}?item_token=#{@current_item&.token}&node_module_token=#{@context}",
                                            next_button: @next_button,
                                            has_video_resolution: false,
                                            disabled: true,
                                            controller: "getBffApi",
                                            endpoint: "user/contents/exercise/#{medium.token}",
                                            resolution_button: { children: 'Ver resolução' },
                                            resolution_children: correction,
                                            children: [
                                              DesignSystem::DangerousHtml.html(medium_text)
                                            ],
                                            list: answers)

        end

        def items_list
          return @items_list = [] if @current_module.nil?

          active_passed = false
          @items_list = @current_module.active_children.map do |item|
            children = nil
            active = @current_item.token == item.token
            if active # TODO validar também se é um exercício
              children = [] # TODO adicionar exercícios de dentro do item ativo na sidebar
            end
            if active_passed && !@next_button
              @next_button = {
                label: 'Próxima aula',
                href: ItemsListElement.new(item, active: active, context: @context).route,
              }
            end
            active_passed = true if active
            ItemsListElement.new(item, active: active, context: @context, children: children, exercise_token: @content.token).render
          end
        end

        def load_content_list
          return @list = [] if @current_module.nil?
          @list = @current_module.active_children.map do |child|
            {
              "icon": { "name": "checkmark-circle", "color": "var(--color-neutral-500)" },
              "title": child.name,
              "permalink": child.main_permalink.slug,
              "link": { "href": "/app/conteudos/#{child.token}" }
            }
          end
        end

        private

        def correction
          return nil if @content.correction.blank?
          result = []
          result << DesignSystem::Video.from_medium(@content) unless @content.video_id.blank?
          result << DesignSystem::DangerousHtml.html(@content.correction)
          result
        end

        def context_parent
          if @context.nil?
            @current_item = @content.parents&.first
            return nil if @current_item.nil?
            return @current_item.parents&.first
          end
          #TODO pegar o item correto entre o módulo de contexto e a mídia caso seja outro item
          @current_item = @content.parents&.first
          NodeModule.find_by_token(@context)
        end

        def set_parent_item
          if @context.nil?
            return @current_item = @content.parents.first
          end
          #TODO pegar o item correto entre o módulo de contexto e a mídia caso seja outro item
          @current_item = @content.parents&.first
        end

        def set_parent_module
          return @current_module = NodeModule.find_by_token(@context) unless @context.nil?
          @current_module = @current_item.parents.first unless @current_item.nil?
        end

        def item
          @content.parents.first #TODO encontrar o item correto entre o módulo (context) e a mídia (content)
        end

        def context_sufix
          @context ? "?contexto=#{@context}" : ''
        end

        def set_exercise_number
          @next_button = nil
          @number = 0
          active_passed = false
          next_exercise = nil
          return nil if @current_item.nil?
          @current_item.active_children.each_with_index do |medium, index|
            active = @content.token == medium.token
            if active_passed && next_exercise.nil?
              next_exercise = medium
              @next_button = {
                label: 'Próximo exercício',
                href: "/app/exercicio/#{medium.token}#{context_sufix}"
              }
            end
            if active
              @number = index + 1
              active_passed = true
            end
          end
        end

        def answers
          i = -1
          medium.answers.map do |answer|
            i += 1
            {
              "id": answer.id.to_s,
              "letter": EXERCISE_LETTERS[i],
              "children": answer.text,
              "is_correct": answer.correct,
            }
          end
        end

        def medium
          @medium ||= @content
        end

        def medium_text
          medium.medium_text
        end

        def set_context(context)
          return @context = context if context
          return nil unless @content.parents.first&.parents&.first

          @context = @content.parents.first&.parents&.first&.token
        end
      end
    end
  end
end


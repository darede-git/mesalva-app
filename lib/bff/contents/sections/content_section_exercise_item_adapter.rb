# frozen_string_literal: true

module Bff
  module Contents
    module Sections
      class ContentSectionExerciseItemAdapter < ContentSectionAdapterBase
        def initialize(content, **attr)
          @content = content
          @page_component = 'ConsoleTemplate'
          @title = @content.parents.first&.name
          set_context(attr[:context])
          set_parent_item
          set_parent_module
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

        def sections
          @next_button = nil
          set_exercises_navigation
          set_items_list
          [
            # TODO generalizar para todas as mídias (INICIO)
            DesignSystem::Breadcrumb.content_go_back(@context),
            {
              "component": "ConsoleContent",
              "title": "Questão #{@number.to_s.rjust(2, '0')}",
              "difficulty": @content.difficulty,
              "event_slug": "exercises/#{@context}/#{@current_item&.token}/#{@content.token}",
              "rating_slug": "rating/#{@content.token}?context=#{@context}/#{@current_item&.token}",
              "report_href": "https://mesalva.com/redirects/typeform/yaUQOR8c?permalink=#{@content.main_permalink&.slug}&token=#{@content.token}",
              # TODO generalizar para todas as mídias (FIM)
              "children": [
                DesignSystem::ExerciseList.render(event_slug: "exercises/#{@context}/#{@current_item&.token}/#{@content.token}",
                                                  next_button: @next_button,
                                                  has_video_resolution: false, #TODO
                                                  resolution_button: {
                                                    children: 'Ver resolução'
                                                  },
                                                  resolution_children: correction,
                                                  children: [
                                                    DesignSystem::Text.render(html: medium_text)
                                                  ],
                                                  list: answers)
              ]
            }
          ]
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

        def set_items_list
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
            ItemsListElement.new(item, active: active, context: @context, children: children).render
          end
        end

        def item
          @content.parents.first #TODO encontrar o item correto entre o módulo (context) e a mídia (content)
        end

        def context_sufix
          @context ? "?contexto=#{@context}" : ''
        end

        def set_exercises_navigation
          @exercises_navigation = []
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
            @exercises_navigation << {
              "title": (index + 1).to_s.rjust(2, '0'),
              "is_current": active,
              "href": "/app/exercicio/#{medium.token}#{context_sufix}"
            }
          end

          @exercises_navigation
        end

        def answers
          letters = %w[A B C D E]
          i = -1
          medium.answers.map do |answer|
            i += 1
            {
              "id": answer.id.to_s,
              "letter": letters[i],
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


# frozen_string_literal: true

module Bff
  module Contents
    module Sections
      class ContentSectionExerciseListAdapter < ContentSectionAdapterBase
        def initialize(content, **attr)
          @content = content
          @page_component = 'ConsoleTemplate'
          @context = attr[:context]
          @title = @content.name
        end

        def render(entity_type)
          context_sufix = @context ? "?contexto=#{@context}" : ''
          redirect_to("/app/#{entity_type}/#{@content.active_children.first.token}#{context_sufix}", @page_component)
        end
      end
    end
  end
end

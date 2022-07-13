# frozen_string_literal: true

module Bff
  module Contents
    class ContentPageAdapter
      attr_reader :content

      CONTENT_ADAPTERS = {
        default: Sections::ContentSectionDefaultAdapter,
        node_test_repository_group: Sections::ContentSectionTestRepositoryGroupAdapter,
        node_prep_test: Sections::ContentSectionPrepTestAdapter,
        node_chapter: Sections::ContentSectionChapterAdapter,
        node_area_subject: Sections::ContentSectionAreaSubjectAdapter,
        node_library: Sections::ContentSectionLibraryAdapter,

        node_module_default: Sections::ContentSectionNodeModuleDefaultAdapter,

        item_video: Sections::ContentSectionVideoAdapter,
        item_streaming: Sections::ContentSectionStreamingAdapter,
        item_fixation_exercise: Sections::ContentSectionExerciseListAdapter,
        item_text: Sections::ContentSectionTextAdapter,
        item_essay: Sections::ContentSectionEssayAdapter,

        medium_fixation_exercise: Sections::ContentSectionExerciseItemAdapter,
      }.freeze

      def initialize(token, entity_type = nil, context = nil)
        @token = token
        @entity_type = entity_type
        @context = context
        find_content_by_token
        @adatper = select_adapter
      end

      def self.render_page(token, entity_type = nil, context)
        self.new(token, entity_type, context).render
      end

      def load_content_list
        @adatper.load_content_list
      end

      def items_list
        @adatper.items_list
      end

      def render
        @adatper.render(@entity_type)
      end

      def list
        @adatper.list
      end

      def sections
        @adatper.sections
      end

      def page_component
        @adatper.page_component
      end

      def find_content_by_token
        [Node, NodeModule, Item, Medium].detect { |model| @content = model.find_by_token(@token) }
        @content
      end

      def update(params)
        permitted_params = filter_update_params_from_content_type(params)
        @content.update(permitted_params)
        update_nested_attributes(params)
      end

      def to_h
        JSON.parse(@content.to_json)
      end

      private

      def filter_update_params_from_content_type(params)
        if @content.entity_type?(:node)
          return params.permit(:name, :token, :active, :listed, :description, :color_hex, options: {})
        end
        if @content.entity_type?(:medium)
          return params.permit(:name, :token, :active, :listed, :medium_text, options: {})
        end
        params.permit(:name, :token, :active, :listed, options: {})
      end

      def update_nested_attributes(params)
        return nil unless @content.entity_type?(:medium)

        permitted_params = params.permit(answers: [:id, :correct, :text])

        permitted_params[:answers].each do |answer_params|
          answer = Answer.find(answer_params[:id])
          answer.update(answer_params.permit(:correct, :text))
        end
      end

      def select_adapter
        adapter = CONTENT_ADAPTERS[@content.full_type.to_sym]
        adapter = CONTENT_ADAPTERS[:default] if adapter.nil?
        adapter.new(@content, context: @context)
      end
    end
  end
end

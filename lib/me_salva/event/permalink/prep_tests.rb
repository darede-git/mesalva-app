# frozen_string_literal: true

module MeSalva
  module Event
    module Permalink
      class PrepTests
        def initialize(user, node_module_slug, full = false)
          @user = user
          @node_module_slug = node_module_slug
          @full = full
        end

        def results
          return unless @node_module_slug

          query_response
        end

        private

        def query_response
          unless @full
            return LessonEvent
                     .prep_test_only
                     .select(:submission_token, :item_slug, "lesson_events.created_at as submission_at, '-' as item_name")
                     .by_user_module_slug(@user, @node_module_slug)
                     .order('lesson_events.id DESC')
          end
          LessonEvent
            .select(:submission_token, "lesson_events.created_at as submission_at, items.name as item_name, items.slug as item_slug")
            .prep_test_only
            .by_user_module_slug(@user, @node_module_slug)
            .joins('INNER JOIN items ON items.slug = lesson_events.item_slug')
            .order('lesson_events.id DESC')
        end
      end
    end
  end
end

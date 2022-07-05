# frozen_string_literal: true

require 'me_salva/event/common'

module MeSalva
  module Event
    module Permalink
      class Query
        attr_reader :group_by

        include MeSalva::Event::Common
        ALLOWED_GROUP_ENTITIES = %(node node_module item medium)

        def initialize(attrs)
          @source = attrs[:source]
          @user_id = attrs[:user_id]
          @permalink = attrs[:permalink]
          @group_by = attrs[:group_by]
          @expanded = attrs[:expanded]
        end

        def results
          source_query = @source.__elasticsearch__.search(query)
          return if source_query.nil?

          source_query.response['aggregations']['group']['buckets']
        end

        def expanded?
          @expanded == 'true'
        end

        def expanded_group_by?
          expanded? && group_by
        end

        private

        def query
          {
            size: 0, query: query_filters,
            aggs: {
              group: {
                terms: { size: 200, field: group_term },
                aggs: sub_aggs
              }
            }
          }
        end

        def group_term
          if @group_by.nil?
            return 'permalink_medium_slug' if expanded?

            return 'permalink_medium_type'
          end
          return "permalink_#{@group_by}_slug" if ALLOWED_GROUP_ENTITIES
                                                  .include? @group_by

          raise ArgumentError
        end

        def query_filters
          {
            bool: {
              must: { prefix: { 'permalink_slug.raw': @permalink } },
              filter: { match: { user_id: @user_id } },
              should: consumption_events, minimum_should_match: 1
            }
          }
        end

        def sub_aggs
          if expanded_group_by?
            return { group: {
              terms: { size: 200, field: 'permalink_medium_slug' },
              aggs: top_hits
            } }
          end
          return top_hits if expanded?

          return grouped_cardinality if group_by

          { distinct_medium_count: cardinality }
        end

        def top_hits
          { group_docs: {
            top_hits: {
              '_source': {
                includes: %w[ permalink_medium_slug created_at
                              permalink_answer_correct permalink_answer_id]
              },
              size: 1, sort: [{ created_at: { order: 'desc' } }]
            }
          } }
        end

        def grouped_cardinality
          {
            group: {
              terms: { size: 200, field: 'permalink_medium_type' },
              aggs: { distinct_medium_count: cardinality }
            }
          }
        end

        def cardinality
          { cardinality: {
            field: 'permalink_medium_id',
            precision_threshold: 1000
          } }
        end
      end
    end
  end
end

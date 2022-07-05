# frozen_string_literal: true

module MeSalva
  module Event
    module User
      module PermalinkData
        def current_consumed_module_data
          {
            node_module_id: current_node_module.id,
            permalink: crop_module_permalink(current_slug,
                                             current_node_module.slug),
            node: current_education_segment.name,
            node_slug: current_education_segment.slug,
            node_module: current_node_module.name,
            node_module_slug: current_node_module.slug,
            created_at: current_ftime
          }
        end

        def current_education_segment
          permalink.nodes.first
        end

        def current_node_module
          permalink.node_module
        end

        def current_slug
          permalink.slug
        end

        def current_medium
          permalink.medium
        end

        def current_medium_type
          @current_medium_type ||= permalink.medium.medium_type.dasherize
        end

        def current_ftime
          Time.now.strftime('%Y-%m-%d %H:%M:%S.%9N %z')
        end

        private

        def crop_module_permalink(raw_permalink, splitter)
          raw_permalink[/.*#{splitter}/m]
        end
      end
    end
  end
end

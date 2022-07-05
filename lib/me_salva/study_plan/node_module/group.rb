# frozen_string_literal: true

module MeSalva
  module StudyPlan
    module NodeModule
      class Group
        attr_reader :available_modules, :ids_to_skip

        def initialize(attrs)
          @available_modules = attrs[:available_modules]
          @ids_to_skip = attrs[:ids_to_skip]
        end

        def by_subject_id_and_relevancy
          available_modules.each_with_object({}) do |uam, subjects|
            next if skip_node_module?(uam)

            values = extract_row_values(uam)
            fill_subjects_defaults(subjects, values)
            add_node_module_to_group(subjects, values)
            sum_relevancy_hours_duration(subjects, values)
          end
        end

        private

        def skip_node_module?(node_module)
          ids_to_skip.include?(node_module['node_module_id'].to_i)
        end

        def sum_relevancy_hours_duration(group, values)
          group[values[:subject_id]][values[:relevancy]]['hours_duration'] +=
            values[:hours_duration]
        end

        def add_node_module_to_group(group, values)
          group[values[:subject_id]][values[:relevancy]]['node_modules'] << \
            { 'id' => values[:node_module_id] }
        end

        def extract_row_values(row)
          node_module_id, relevancy, subject_id, hours_duration = row.values
          { node_module_id: node_module_id,
            relevancy: relevancy.to_i,
            subject_id: subject_id,
            hours_duration: hours_duration.to_f }
        end

        def fill_subjects_defaults(obj, values)
          obj[values[:subject_id]] ||= {}
          obj[values[:subject_id]][values[:relevancy]] ||= \
            { 'node_modules' => [], 'hours_duration' => 0.to_f }
        end
      end
    end
  end
end

# frozen_string_literal: true

module MeSalva
  module StudyPlan
    module NodeModule
      class Collector
        attr_reader :available_node_modules
        attr_accessor :available_time

        def initialize(attrs = {})
          @available_node_modules = attrs[:available_node_modules]
          @available_time = attrs[:available_time]
          @consumable_modules = []
          @current_relevancy = 1
        end

        def collect_for_available_time
          collect_consumable_modules_for_relevancy while enough_time_and_modules?
          consumable_modules
        end

        private

        def collect_consumable_modules_for_relevancy
          available_node_modules.each do |subject_id, relevancies|
            next unless collect_current_relevancy_modules(relevancies)

            clean_available_modules(subject_id)
          end
          increment_current_relevancy
        end

        def increment_current_relevancy
          @current_relevancy += 1
        end

        def consumable_modules
          @consumable_modules.flatten!
        end

        def enough_time_and_modules?
          available_time.positive? && available_node_modules.any?
        end

        def clean_available_modules(subject_id)
          available_node_modules[subject_id].delete(@current_relevancy)
          return unless available_node_modules[subject_id].empty?

          available_node_modules.delete(subject_id)
        end

        def collect_current_relevancy_modules(relevancies)
          return false if available_time <= 0

          return false if relevancies[@current_relevancy].nil?

          @consumable_modules << attributes_for(relevancies)

          subtract_from_available_time(
            module_relevancy_hours_duration(relevancies)
          )
        end

        def subtract_from_available_time(hours)
          self.available_time -= hours
        end

        def module_relevancy_hours_duration(relevancies)
          relevancies[@current_relevancy]['hours_duration']
        end

        def attributes_for(relevancies)
          relevancies[@current_relevancy]['node_modules']
        end
      end
    end
  end
end

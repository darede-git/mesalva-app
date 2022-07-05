# frozen_string_literal: true

module MeSalva
  module StudyPlan
    class Answers
      extend Forwardable
      attr_reader :shifts

      def_delegators :time, :availability

      def initialize(attrs = {})
        @subject_ids = attrs[:subject_ids]
        @shifts = attrs[:shifts]
        @end_date = attrs[:end_date]
        @keep_completed_modules = attrs[:keep_completed_modules]
      end

      def valid?
        true unless missing_answers.any?
      end

      def errors
        missing_answers
      end

      def available_time
        return 0 unless valid?

        availability
      end

      def subject_ids
        return [] unless valid?

        @subject_ids
      end

      def keep_completed_modules?
        return false unless valid?

        @keep_completed_modules
      end

      def start_date
        DateTime.now
      end

      def end_date
        DateTime.parse(@end_date)
      end

      private

      def missing_answers
        @errors ||= %w[subject_ids shifts end_date]
                    .map do |name|
          present = instance_variable_get("@#{name}").present?
          "Answer #{name} is not present" unless present
        end
        @errors.compact
      end

      def time
        @time ||= MeSalva::StudyPlan::Time.new(@shifts, start_date, end_date)
      end
    end
  end
end

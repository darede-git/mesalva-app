# frozen_string_literal: true

module MeSalva
  module Logs
    class Statistic
      def initialize(log_object, category)
        @log = log_object
        @category = category
      end

      def save
        InternalLog.create(log: @log,
                           category: @category,
                           log_type: 'Statistic')
      end

      def increment_counter(item)
        @log[item] = @log[item] + 1
      end
    end
  end
end

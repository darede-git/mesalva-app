# frozen_string_literal: true

module MeSalva
  module Logs
    class Message
      def initialize(category)
        @category = category
      end

      def save(message, log_type = 'Message')
        InternalLog.create(log: message,
                           category: @category,
                           log_type: log_type)
      end
    end
  end
end

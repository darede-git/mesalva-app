# frozen_string_literal: true

module MeSalva
  module Error
    class NonexistentColumnError < StandardError
      attr_reader :message

      def initialize
        @message = I18n.t('nonexistent_column')
        super(@message)
      end
    end
  end
end

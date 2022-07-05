# frozen_string_literal: true

module MeSalva
  module Error
    class TriApiConnectionError < StandardError
      attr_reader :message, :status_code, :body

      def initialize(status_code, body)
        @message = I18n.t('prep_test.tri.api_connection_error')
        @status_code = status_code
        @body = body
        super(@message)
      end
    end
  end
end

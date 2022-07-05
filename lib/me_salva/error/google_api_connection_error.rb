# frozen_string_literal: true

module MeSalva
  module Error
    class GoogleApiConnectionError < StandardError
      attr_reader :message, :status_code, :body

      def initialize(status_code, body)
        @message = I18n.t('google.api_connection_error')
        @status_code = status_code
        @body = body
        super(@message)
      end
    end
  end
end

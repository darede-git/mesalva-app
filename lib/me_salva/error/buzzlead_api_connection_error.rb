# frozen_string_literal: true

module MeSalva
  module Error
    class BuzzleadApiConnectionError < StandardError
      attr_reader :message, :status_code, :body

      def initialize(status_code, body)
        @message = body['message']
        @status_code = status_code
        @body = body
        super(@message)
      end
    end
  end
end

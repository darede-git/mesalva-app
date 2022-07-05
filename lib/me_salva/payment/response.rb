# frozen_string_literal: true

module MeSalva
  module Payment
    class Response
      def initialize(response)
        @response = response
      end

      def id
        @response.id
      end

      def method_missing(name, *args, &block)
        if @response.respond_to?(name)
          @response.public_send(name, *args, &block)
        else
          super
        end
      end

      def respond_to_missing?(method_name, include_private = false)
        super
      end
    end
  end
end

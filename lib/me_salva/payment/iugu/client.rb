# frozen_string_literal: true

require 'iugu'

module MeSalva
  module Payment
    module Iugu
      module Client
        def set_api_key
          ::Iugu.api_key ||= ENV['IUGU_API_KEY']
          nil
        end
      end
    end
  end
end

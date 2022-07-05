# frozen_string_literal: true

module MeSalva
  module Crm
    module Rdstation
      class Authentication
        def initialize
          @response = auth.update_access_token(ENV['RDSTATION_RESET_TOKEN'])
        end

        def access_token
          @access_token ||= @response['access_token']
        end

        private

        def auth
          RDStation::Authentication.new(ENV['RDSTATION_CLIENT_ID'],
                                        ENV['RDSTATION_CLIENT_SECRET'])
        end
      end
    end
  end
end

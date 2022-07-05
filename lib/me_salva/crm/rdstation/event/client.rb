# frozen_string_literal: true

module MeSalva
  module Crm
    module Rdstation
      module Event
        class Client
          def initialize(**params)
            @user = params[:user]
            @event_name = params[:event_name]
            @payload = params[:payload]
          end

          def create
            return if invalid_user?

            client.create(body)
          end

          private

          def invalid_user?
            @user.crm_email.blank?
          end

          def default_payload
            {
              conversion_identifier: @event_name,
              name: @user.name,
              email: @user.crm_email,
              mobile_phone: @user.phone
            }
          end

          def client
            RDStation::Events.new(access_token)
          end

          def access_token
            Authentication.new.access_token
          end

          def body
            {
              event_type: 'CONVERSION',
              event_family: 'CDP',
              payload: @payload.merge(default_payload)
            }
          end
        end
      end
    end
  end
end

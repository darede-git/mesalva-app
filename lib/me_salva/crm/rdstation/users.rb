# frozen_string_literal: true

module MeSalva
  module Crm
    module Rdstation
      class Users
        def initialize(user)
          @contacts = RDStation::Contacts.new(Authentication.new.access_token)
          @user = user
        end

        def update_attribute(attribute, new_value)
          rdstation_user.update(attribute.to_sym => new_value)
        rescue RDStation::Error::ResourceNotFound => e
          NewRelic::Agent.notice_error(e, response_body: e.body, status_code: e.http_status)
        end

        private

        def rdstation_user
          @contacts.by_email(@user.email)
        end
      end
    end
  end
end

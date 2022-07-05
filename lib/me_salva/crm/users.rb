# frozen_string_literal: true

require 'intercom'
require 'me_salva/crm/client'
require 'active_support/core_ext/enumerable'

module MeSalva
  module Crm
    class Users
      include MeSalva::Crm
      include CrmEventsParamsHelper

      def initialize; end

      def create(user, **attr)
        return if user.crm_email.nil?

        user = new_user(user)
        update_sign_up(user)
        change(user, attr)
      end

      def find_by_uid(uid)
        client.users.find(user_id: uid)
      end

      def destroy(user)
        user = client.users.find(user_id: user.uid)
        client.users.delete(user)
      end

      def update(user, **attr)
        user = new_user(user)
        change(user, attr)
      end

      def destroy_duplicated(resource)
        destroy(resource)
        intercom_user = client.users.find(user_id: resource.id)
        intercom_user.user_id = resource.uid
        client.users.save(intercom_user)
      end

      private

      def new_user(user)
        client.users.create(user_id: user.uid,
                            email: user.crm_email,
                            name: user.name)
      end

      def update_sign_up(user)
        user.signed_up_at = Time.now.to_i
        client.users.save(user)
      end

      def change(user, attributes)
        user.last_request_at = Time.now
        attributes.each do |key, value|
          user.custom_attributes[key] = value
        end
        client.users.save(user)
      end
    end
  end
end

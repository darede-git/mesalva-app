# frozen_string_literal: true

module MeSalva
  module Crm
    class ChatGuru
      def initialize(user)
        @user = user
      end

      def send_message(text, date = nil)
        raise I18n.t("crm.chat_guru.user_without_phone") if phone_invalid?
        raise I18n.t("crm.chat_guru.no_permission_to_receive_message") unless user_has_permission?

        @text = text
        @date = date || DateTime.now.strftime('%Y-%m-%d %H:%M')
        send_request
      end

      private

      def user_has_permission?
        Permission.validate_user('chat_guru', 'receive_message', @user)
      end

      def phone_invalid?
        @user.phone_area.blank? || @user.phone.blank?
      end

      def chat_params
        {
          action: 'chat_add',
          text: @text,
          send_date: @date,
          key: ENV['CHATGURU_KEY'],
          account_id: ENV['CHATGURU_ACCOUNT_ID'],
          phone_id: ENV['CHATGURU_PHONE_ID'],
          chat_number: chat_number,
          name: chat_name
        }
      end

      def chat_number
        "55#{@user.phone_area}#{@user.phone_number}"
      end

      def chat_name
        "auto-#{@user.uid}"
      end

      def send_request
        HTTParty.post("https://s14.chatguru.app/api/v1?#{chat_params.to_query}")
      end
    end
  end
end

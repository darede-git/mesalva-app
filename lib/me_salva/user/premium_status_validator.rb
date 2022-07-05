# frozen_string_literal: true

module MeSalva
  module User
    class PremiumStatusValidator
      def initialize(user)
        @user = user
      end

      def intercom_status
        return ::User::PREMIUM_STATUS[:student_lead] if student_lead?

        return ::User::PREMIUM_STATUS[:subscriber] if subscriber?

        return ::User::PREMIUM_STATUS[:unsubscriber] if unsubscriber?

        ::User::PREMIUM_STATUS[:ex_subscriber] if ex_subscriber?
      end

      def rd_status(event_type)
        @event_type = event_type
        @order = Order.by_user(@user).first
        @old_access = ::Access.last_before_purchase(@user.id).last
        return :error unless @order.present? && @event_type.present?

        return :upsell_client if upsell_client?

        return :repurchase_client if repurchase_client?

        return :ex_client if ex_client?

        return :client if client?

        :another_client_type
      end

      private

      def client?
        purchase_event? && @old_access.nil?
      end

      def ex_client?
        expiration_event? && @old_access.present?
      end

      def expiration_event?
        @event_type == :expiration_event
      end

      def repurchase_client?
        purchase_event? && been_premium? && @old_access.present? &&
          (@old_access.inactive_account? ||
            (@old_access.active_account? && @old_access.about_to_expire?))
      end

      def upsell_client?
        purchase_event? &&
          been_premium? &&
          @old_access.present? &&
          @old_access.active_account? &&
          @order.upgrade_plan?
      end

      def purchase_event?
        @event_type == :purchase_event
      end

      def student_lead?
        never_been_premium?
      end

      def subscriber?
        @user.premium?
      end

      def unsubscriber?
        @user.not_premium? &&
          been_premium? &&
          unsubscriber_last_access?
      end

      def ex_subscriber?
        @user.not_premium? &&
          been_premium? &&
          ex_subscriber_last_access?
      end

      def unsubscriber_last_access?
        last_access_order.present? &&
          !last_access_order.refunded? &&
          !last_access_order.subscription?
      end

      def ex_subscriber_last_access?
        last_access_order.present? &&
          (last_access_order.refunded? ||
          last_access_order.subscription?)
      end

      def been_premium?
        user_accesses.count.positive?
      end

      def never_been_premium?
        user_accesses.count.zero?
      end

      def last_access_order
        user_accesses.last.order
      end

      def user_accesses
        ::Access.by_user(@user)
      end
    end
  end
end

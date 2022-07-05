# frozen_string_literal: true

module MeSalva
  module User
    class ContestAccess
      include IntercomHelper

      def perform(access)
        active_accesses = ::Access.valid(access.user, access.package)
        remove_access(access, active_accesses) if active_accesses
        update_intercom_user_plan(access)
        send_remove_email(access) if access.voucher
      end

      private

      def remove_access(access, active_accesses)
        return access.deactivate if subscription_or_unique(access, active_accesses)

        deduct_access(access, active_accesses)
      end

      def update_intercom_user_plan(access)
        update_intercom_user(access.user, plan: active_plans_slugs(access)) if access.user.premium?
        update_intercom_user(access.user,
                             subscriber: ::User::PREMIUM_STATUS[:ex_subscriber], plan: '')
      end

      def active_plans_slugs(access)
        access.actives_package_slug
      end

      def subscription_or_unique(access, active_accesses)
        access.order&.subscription? || unique_access?(active_accesses)
      end

      def deduct_access(access, active_accesses)
        return access.deactivate if date_fixed?(access)

        balance = access.package.duration
        deduct_other_accesses(access, active_accesses, balance)
        access.deactivate
      end

      def date_fixed?(access)
        access.package.expires_at?
      end

      def deduct_other_accesses(current_access, active_accesses, deduct_time)
        active_accesses.order(:expires_at).each do |access|
          found_current_access(access, current_access)
          next unless @access_to_deactivate

          access.expires_at -= deduct_time.months
          access.save
        end
      end

      def found_current_access(access, current_access)
        @access_to_deactivate = current_access if access == current_access
      end

      def unique_access?(active_accesses)
        active_accesses.size == 1
      end

      def send_remove_email(access)
        VoucherMailer.remove_access_email(access.user).deliver_now
      end
    end
  end
end

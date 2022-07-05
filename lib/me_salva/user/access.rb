# frozen_string_literal: true

require 'me_salva/user/access_expiration_date'
require 'me_salva/user/contest_access'
module MeSalva
  module User
    class Access
      include UtmHelper
      include CrmEvents

      def create(user, package, params = {})
        create_crm_access(user)
        if params[:order]
          @order = params[:order]
          active_accesses = ::Access.valid(user, package)
          params[:accesses] = active_accesses
          params[:package] = package
        end

        params[:starts_at] = Time.now.utc
        params[:expires_at] = AccessExpirationDate.new.to_date(params)
        main_access_created = create_access(user, package, params)
        create_complementary_accesses(user, params) if complementary_packages?
        user.state_machine.transition_to(:subscriber)
        main_access_created
      end

      def contest(access)
        ContestAccess.new.perform(access)
        access.user.state_machine.transition_to(:ex_subscriber) if access.unique?
      end

      private

      def complementary_packages?
        @order.present? && @order.complementary_package_ids.present?
      end

      def create_complementary_accesses(user, params)
        @order.complementary_packages.each do |complementary_package|
          create_access(user, complementary_package, params)
        end
      end

      def create_crm_access(user)
        return create_crm('account_upgrade', user) if upgrade?(user)

        create_crm('account_upsell', user)
      end

      def upgrade?(user)
        ::Access.by_user_active_in_range(user).count.zero?
      end

      def create_access(user, package, **meta)
        ::Access
          .create(user: user, package: package,
                  starts_at: meta[:starts_at], expires_at: meta[:expires_at],
                  order: meta[:order], gift: meta[:gift],
                  created_by: meta[:created_by], platform_id: meta[:platform_id])
      end
    end
  end
end

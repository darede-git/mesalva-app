# frozen_string_literal: true

module MeSalva
  module Payment
    class Discount
      def valid?(package, discount, user)
        @package = package
        @discount = discount
        @user = user
        return false unless entities?

        return false if subscription?

        %i[package_related? in_range? user? upsell? only_customer?].all? do |m|
          send(m)
        end
      end

      private

      def entities?
        @package && @discount
      end

      def package_related?
        for_all_packages? || package_included?
      end

      def for_all_packages?
        @discount.packages.include?("*")
      end

      def package_included?
        @discount.packages.include?(@package.id.to_s)
      end

      def subscription?
        @package.subscription
      end

      def in_range?
        DateTime.now.between?(@discount.starts_at,
                              @discount.expires_at) || discount_only_for_customers?
      end

      def user?
        return true if for_all_users?

        @discount.user_id == @user.id
      end

      def for_all_users?
        @discount.user_id.nil?
      end

      def upsell?
        return true if upsell_type?

        Access
          .paid_access_by_user_and_packages(@user.id, @discount.upsell_packages)
          .present?
      end

      def upsell_type?
        @discount.upsell_packages.nil?
      end

      def only_customer?
        return true unless discount_only_for_customers?

        return true if valid_costumer?

        false
      end

      def valid_costumer?
        valid_expiration_date?
      end

      def set_dates
        @expiration_date = Access.where(user_id: @user.id,
                                        package_id: @package.id)
                                 .last
                                 .expires_at
        @initial_date = @expiration_date - 30.days
        @final_date = @expiration_date + 15.days
      end

      def valid_expiration_date?
        set_dates
        Date.today >= @initial_date && Date.today <= @final_date
      end

      def discount_only_for_customers?
        @discount.only_customer?
      end
    end
  end
end

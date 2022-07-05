# frozen_string_literal: true

module MeSalva
  module User
    class AccessExpirationDate
      def to_date(params)
        return parse_date(params[:expires_at]) if params[:expires_at].present?

        if params[:order]
          expire_date(params[:order], params[:package], params[:accesses])
        elsif params[:gift]
          gift_expires_date(params[:duration])
        end
      end

      private

      def parse_date(date)
        return date if date.match(/^\d{4}-\d{2}-\d{2}$/).blank?

        DateTime.parse(date) + 1.day - 1.minute
      end

      def expire_date(order, package, accesses)
        return subscription_expire_date(order) if order.subscription?

        return package.expires_at unless package.duration

        return first_access_due_date(package) if accesses.empty?

        accesses.last.expires_at + package.duration.months
      end

      def gift_expires_date(duration)
        Time.now + duration.to_i.days
      end

      def first_access_due_date(package)
        Time.now + package.duration.months
      end

      def subscription_expire_date(order)
        order.expires_at + ::Access::SUBSCRIPTION_ADDITIONAL_TIME
      end
    end
  end
end

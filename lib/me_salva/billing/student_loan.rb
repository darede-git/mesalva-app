# frozen_string_literal: true

module MeSalva
  module Billing
    class StudentLoan
      def initialize(order_params, user_uid)
        @params = order_params
        @user = ::User.find_by_uid(user_uid)
      end

      def created_student_loan
        order = Order.new(valid_params)
        return order unless order.save
        order.transition_to_paid
        order
      end

      private

      def valid_params
        price_paid = @params[:price_paid] || 0
        @params.merge(user: @user, checkout_method: 'bank_slip', status: 1,
                      currency: 'BRL', price_paid: price_paid)
      end
    end
  end
end

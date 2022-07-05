# frozen_string_literal: true

require 'pagarme'

module MeSalva
  module Payment
    module Pagarme
      class Reprocess
        include Client

        def initialize
          set_api_key
        end

        def by_order(order)
          @order = order
          confirm_payment
          confirm_access
        end

        private

        def confirm_payment
          return confirm_multiple_payments if @order.checkout_method == 'multiple'

          return nil if @order.payments.empty?
          confirm_single_payment if @order.payments.count == 1
        end

        def confirm_multiple_payments
          return unless @order.status == 1
          return grant_access if @order.payments.all?{|p| p.status == 'captured'}

            @order.payments.each do |payment|
              transaction_id = payment.pagarme_transaction.transaction_id
              pagarme_transaction = ::PagarMe::Transaction.find(transaction_id)
              if payment.status != 'captured' && pagarme_transaction.status == 'paid'
                payment.state_machine.transition_to('captured')
              end
            end
          grant_access if @order.payments.all?{|p| p.status == 'captured'}
        end

        def grant_access
          main_access.where(gift: true, package_id: @order.package_id).update(active: false)
          @order.transition_to_paid
          main_access.where(order_id: @order.id).update(starts_at: @order.created_at)
        end

        def main_access
          Access.where(package_id: @order.package_id, user_id: @order.user_id, active: true)
        end

        def confirm_single_payment
          payment = @order.payments.first
          transaction_id = payment.pagarme_transaction.transaction_id
          pagarme_transaction = ::PagarMe::Transaction.find(transaction_id)
          raise "Order not paid: #{pagarme_transaction.status}" if pagarme_transaction.status != 'paid'
          grant_access if pagarme_transaction.status == 'paid' && @order.status != 2
        end

        def confirm_access
          return unless @order.status == 2 && @order.accesses.count.zero?
          last_access = Access.where('order_id IS NULL').by_user(@order.user).by_package(@order.package).last
          if last_access
            last_access.update(order_id: @order.id) if last_access.expires_at >= (last_access.created_at + @order.package.duration.months - 1.days)
          else
            MeSalva::User::Access.new.create(@order.user, @order.package, order: @order)
          end
        end
      end
    end
  end
end


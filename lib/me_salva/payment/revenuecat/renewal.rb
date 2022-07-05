# frozen_string_literal: true

module MeSalva
  module Payment
    module Revenuecat
      class Renewal < Postback
        attr_reader :renewal_transaction_id,
                    :purchase_index,
                    :last_store_transaction,
                    :next_expiration_date,
                    :last_transaction_id

        def initialize(metadata = {})
          super(metadata)
          set_renewal_transaction_id
          set_last_transaction_id
          set_last_store_transaction
          set_purchase_index
          set_next_expiration_date
        end

        def set_renewal_transaction_id
          @renewal_transaction_id =
            if play_store?
              @metadata[:transaction_id].to_s
            else
              "#{@metadata[:original_transaction_id]}..#{count_previous_transactions}"
            end
        end

        def set_last_transaction_id
          @last_transaction_id = store_last_transaction_id
        end

        def set_purchase_index
          @purchase_index = if play_store?
                              @metadata[:transaction_id].split('..').last.to_i
                            else
                              count_previous_transactions
                            end
        end

        def set_last_store_transaction
          @last_store_transaction = find_last_store_transaction
        end

        def set_next_expiration_date
          @next_expiration_date = Date.today + 30.days
        end

        def store_last_transaction_id
          return play_store_last_transaction_id if play_store?

          app_store_last_transaction_id
        end

        def play_store_last_transaction_id
          return @original_transaction_id if @metadata[:transaction_id][26..-1] == "0"

          "#{@metadata[:transaction_id][0..26]}#{@metadata[:transaction_id][26..-1].to_i - 1}"
        end

        def app_store_last_transaction_id
          previous_transactions = count_previous_transactions
          return @metadata[:original_transaction_id].to_s if previous_transactions == 1

          "#{@metadata[:original_transaction_id]}..#{previous_transactions}"
        end

        def count_previous_transactions
          AppStoreTransaction.where("transaction_id like '#{@original_app_user_id}%'").count +
            AppStoreTransaction.where("transaction_id like '#{@original_transaction_id}%'").count
        end

        def find_last_store_transaction
          store_transaction_found = @store_transaction.find_by_transaction_id(@transaction_id_old)
          return store_transaction_found if store_transaction_found.present?

          store_transaction_found = @store_transaction.find_by_transaction_id(@last_transaction_id)
          return store_transaction_found if store_transaction_found.present?

          @first_store_transaction
        end

        def subscription_renew
          update_store_transaction_metadata if first_transaction_with_old_id?
          create_subscription if previous_transaction?
        end

        def create_subscription
          MeSalva::Subscription::Order.new(
            @store_transaction.last.order_payment.order,
            order_attributes: new_order_attributes,
            payment_attributes: new_payment_attributes,
            transaction_attributes: new_transaction_attributes
          ).renew
          transit_last_transaction
        end

        def transit_last_transaction
          @store_transaction.last.order_payment.order.state_machine.transition_to!(:paid)
          @store_transaction.last.order_payment.order.accesses.last
                            .update(expires_at: @next_expiration_date)
        end

        def new_order_attributes
          { expires_at: @next_expiration_date,
            status: 2,
            broker_invoice: @renewal_transaction_id }
        end

        def new_payment_attributes
          { payment_method: 'card',
            installments: 1,
            amount_in_cents: @metadata[:price_in_purchased_currency].to_i * 100 }
        end

        def new_transaction_attributes
          { transaction_id: @renewal_transaction_id,
            metadata:
              @last_store_transaction
                .metadata
                .merge!("orderId" => @renewal_transaction_id,
                        "product_id" => @metadata['product_id'],
                        "transaction_id" => @renewal_transaction_id,
                        "original_transaction_id" => @original_transaction_id,
                        "app_user_id" => @metadata['app_user_id'],
                        "original_app_user_id" => @first_store_transaction
                                                  .metadata['original_app_user_id'],
                        "purchased_at_ms" => @metadata['purchased_at_ms'],
                        "store" => @store,
                        "type" => @event_type,
                        "transaction_id_old" => @transaction_id_old,
                        "purchase_index" => @purchase_index + (play_store? ? 1 : 0),
                        "revenuecat_transaction_id" => @metadata[:transaction_id]) }
        end

        def previous_transaction?
          @last_store_transaction.present?
        end
      end
    end
  end
end

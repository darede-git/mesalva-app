# frozen_string_literal: true

module MeSalva
  module Payment
    module Revenuecat
      class Postback < ActiveModelSerializers::Model
        WEBHOOK_AUTH = ENV['REVENUE_CAT_WEBHOOK_AUTH']
        STORES = %w[PLAY_STORE APP_STORE].freeze
        FIELDS = %w[product_id period_type event_timestamp_ms expiration_at_ms environment
                    transaction_id original_transaction_id app_user_id original_app_user_id
                    currency price price_in_purchased_currency store type id purchased_at_ms
                    transaction_id_old].freeze
        ACCEPTED_EVENT_TYPES = %w[INITIAL_PURCHASE RENEWAL].freeze
        DEFAULT_OK = { "revenuecat_information_ok" => "true",
                       "event_type_ok" => "false" }.freeze

        attr_reader :metadata,
                    :store,
                    :store_transaction,
                    :event_type,
                    :original_transaction_id,
                    :transaction_id_old,
                    :first_store_transaction,
                    :original_app_user_id

        def initialize(metadata = {})
          @metadata = metadata
          set_store
          set_event_type
          set_original_transaction_id
          set_original_app_user_id
          set_transaction_id_old
          set_first_store_transaction
        end

        def set_store
          @store = @metadata[:store]
          @store_transaction = PlayStoreTransaction if play_store?
          @store_transaction = AppStoreTransaction unless play_store?
        end

        def set_event_type
          @event_type = @metadata[:type]
        end

        def set_original_transaction_id
          @original_transaction_id = @metadata[:original_transaction_id].to_s
        end

        def set_original_app_user_id
          @original_app_user_id = @metadata[:original_app_user_id].to_s
        end

        def set_transaction_id_old
          purchased_at_ms = @metadata[:purchased_at_ms].to_s[0..-4]
          @transaction_id_old =
            "#{transaction_id_prefix}#{@original_app_user_id}_#{purchased_at_ms}000"
          @metadata.merge!("transaction_id_old": @transaction_id_old,
                           "revenuecat_transaction_id": @metadata[:original_transaction_id].to_s)
        end

        def set_first_store_transaction
          @first_store_transaction = find_first_store_transaction
        end

        def metadata_ok?
          @metadata.present? && (FIELDS - @metadata.keys).empty?
        end

        def valid_store?
          STORES.include?(@store)
        end

        def play_store?
          @store.eql? STORES[0]
        end

        def initial_purchase?
          ACCEPTED_EVENT_TYPES[0].eql?(@event_type)
        end

        def renewal?
          ACCEPTED_EVENT_TYPES[1].eql?(@event_type)
        end

        def valid_event?
          ACCEPTED_EVENT_TYPES.include?(@event_type)
        end

        def default_ok
          DEFAULT_OK.to_json
        end

        def self.valid_signature?(request)
          request.headers['HTTP_AUTHORIZATION'].eql? WEBHOOK_AUTH
        end

        def find_first_store_transaction
          store_transaction_found = @store_transaction.find_by_transaction_id(@transaction_id_old)
          return store_transaction_found if store_transaction_found.present?

          store_transaction_found =
            @store_transaction
            .where("transaction_id like '#{transaction_id_prefix}#{@original_app_user_id}_%'")
            .first
          return store_transaction_found if store_transaction_found.present?

          @store_transaction.find_by_transaction_id(@original_transaction_id)
        end

        def update_store_transaction_metadata
          if renewal?
            metadata_new = @metadata
            metadata_old =
              @metadata.merge("transaction_id": @original_transaction_id,
                              "transaction_id_old": @first_store_transaction.transaction_id,
                              "type": ACCEPTED_EVENT_TYPES[0],
                              "purchase_index": 0)
            @metadata = metadata_new
            @first_store_transaction.update_metadata(metadata_old,
                                                     @original_transaction_id,
                                                     @event_type)
          else
            @metadata.merge!("purchase_index": 0)
            @first_store_transaction.update_metadata(@metadata,
                                                     @original_transaction_id,
                                                     @event_type)
          end
        end

        def first_transaction_with_old_id?
          @store_transaction.find_by_transaction_id(@transaction_id_old).present? ||
            @store_transaction
              .where("transaction_id like '#{transaction_id_prefix}#{@original_app_user_id}_%'")
              .first
              .present?
        end

        def transaction_id_prefix
          'GPA.' if play_store?
        end

        def information_for_update_ok?
          @original_transaction_id.present? && @first_store_transaction.present?
        end
      end
    end
  end
end

# frozen_string_literal: true

class AppStoreTransaction < ActiveRecord::Base
  belongs_to :order_payment

  validates  :transaction_id, presence: true, allow_blank: false
  validates_uniqueness_of :transaction_id

  def order
    order_payment.order
  end

  def update_metadata(metadata, transaction_id, event_type)
    if event_type == 'INITIAL_PURCHASE'
      self.metadata.update(app_store_transaction_params(metadata))
    else
      self.metadata.update(app_store_transaction_from_renewal_params(metadata))
    end
    update(transaction_id: transaction_id)
    save
  end

  def app_store_transaction_params(metadata)
    self.metadata.merge(metadata.permit(:product_id,
                                        :transaction_id,
                                        :original_transaction_id,
                                        :app_user_id,
                                        :original_app_user_id,
                                        :purchased_at_ms,
                                        :type,
                                        :transaction_id_old,
                                        :purchase_index,
                                        :revenuecat_transaction_id))
  end

  def app_store_transaction_from_renewal_params(metadata)
    self.metadata.merge(metadata.permit(:transaction_id,
                                        :original_transaction_id,
                                        :transaction_id_old,
                                        :app_user_id,
                                        :original_app_user_id,
                                        :type,
                                        :purchase_index))
  end

  def last_order
    order_payment.order
  end
end

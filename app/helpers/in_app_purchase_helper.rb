# frozen_string_literal: true

module InAppPurchaseHelper
  private

  def mobile_product_param
    params["broker_product_id"]
  end

  def play_store?
    broker == 'play_store'
  end

  def broker_data
    params['broker_data']
  end

  def broker
    params['broker']
  end

  def expires_at_param
    return broker_data['purchaseTime'].to_i if play_store?

    broker_data['purchase_date_ms'].to_i
  end

  def transaction_id
    broker_data['orderId'] || broker_data['transaction_id']
  end

  def new_payment
    { amount_in_cents: params['amount_in_cents'], installments: 1,
      payment_method: 'card',
      "#{broker}_transaction_attributes": {
        transaction_id: transaction_id, metadata: broker_data
      } }
  end

  def broker_data_attributes
    %i[orderId packageName productId purchaseTime purchaseState
       purchaseToken autoRenewing expires_date_ms
       original_purchase_date_ms original_transaction_id product_id
       purchase_date_ms transaction_id]
  end

  def payments_attributes
    [:amount_in_cents, :installments, :payment_method,
     { play_store_transaction_attributes: [:transaction_id,
                                           { metadata: broker_data_attributes }],
       app_store_transaction_attributes: [:transaction_id,
                                          { metadata: broker_data_attributes }] }]
  end

  def permitted_attributes
    [:broker, :installments, :package_id, :user_id, :price_paid,
     :discount_id, :expires_at, :currency, :broker_invoice,
     { broker_data: broker_data_attributes,
       payments_attributes: payments_attributes,
       utm_attributes: utm_attributes }].concat(update_permitted_attributes)
  end

  def update_permitted_attributes
    [:cpf, :nationality, :payment_proof, :status, :email,
     { address_attributes: address_attributes }]
  end
end

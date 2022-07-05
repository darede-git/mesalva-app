# frozen_string_literal: true

module PostbackHelper
  def subscription_postback(to_status, payment_method)
    { 'object': 'subscription', 'current_status': to_status, 'id': 12_345,
      'desired_status': 'paid', 'event': 'subscription_status_changed',
      'subscription': { 'current_transaction': { 'id': 1_629_762, 'amount': '1000' },
                        'current_period_end': '2017-07-07T14:31:34.417Z',
                        'payment_method': payment_method } }
  end

  def revenuecat_postback(sequence_id, store, transaction_id, type,
                          original_id = "EXAMPLE_TRANSACTION_ID")
    { "product_id" => "assinatura_me_salva_ensino_medio",
      "period_type" => "EXAMPLE", "event_timestamp_ms" => 1_623_335_668_862,
      "expiration_at_ms" => 1_623_342_868_862, "environment" => "SANDBOX",
      "transaction_id" => transaction_id, "original_transaction_id" => original_id,
      "app_user_id" => app_user_id, "original_app_user_id" => app_user_id,
      "currency" => "BRL", "price" => 1.99,
      "price_in_purchased_currency" => 1.99,
      "store" => store, "type" => type,
      "id" => "2B07BDCB-F4A1-4A02-912D-D5703D2A754C",
      "purchased_at_ms" => "222222222#{sequence_id}000" }
  end

  def revenuecat_postback_missing_info(store)
    { "product_id" => "assinatura_me_salva_ensino_medio",
      "event_timestamp_ms" => 1_623_335_668_862,
      "expiration_at_ms" => 1_623_342_868_862,
      "environment" => "SANDBOX",
      "transaction_id" => 'GPA.3345-7300-5002-12345',
      "app_user_id" => app_user_id,
      "original_app_user_id" => app_user_id,
      "price" => 1.99,
      "price_in_purchased_currency" => 1.99,
      "store" => store,
      "id" => "2B07BDCB-F4A1-4A02-912D-D5703D2A754C" }
  end

  # rubocop:disable Metrics/AbcSize
  def new_metadata_expects(**attr)
    expect(attr[:metadata]['product_id']).to eq('assinatura_me_salva_ensino_medio')
    expect(attr[:metadata]['transaction_id']).to eq(attr[:transaction_id])
    expect(attr[:metadata]['original_transaction_id']).to eq(attr[:original_transaction_id])
    expect(attr[:metadata]['app_user_id']).to eq(app_user_id)
    expect(attr[:metadata]['original_app_user_id']).to eq(app_user_id)
    expect(attr[:metadata]['type']).to eq(attr[:type])
    expect(attr[:metadata]['purchased_at_ms']).to eq("222222222#{id}000")
    expect(attr[:metadata]['purchase_index']).to eq(attr[:purchase_index])
    if attr[:store] == 'PLAY_STORE'
      expect(attr[:metadata]['transaction_id_old']).to \
        eq("GPA.#{app_user_id}_222222222#{id}000")
    else
      expect(attr[:metadata]['transaction_id_old']).to \
        eq("#{app_user_id}_222222222#{id}000")
      expect(attr[:metadata]['revenuecat_transaction_id']).to \
        eq(attr[:postback_info]['transaction_id'])
    end
  end

  def first_metadata_expects(metadata, original_transaction_id, store, transaction_id_seq)
    expect(metadata['transaction_id']).to eq(original_transaction_id)
    expect(metadata['original_transaction_id']).to eq(original_transaction_id)
    expect(metadata['app_user_id']).to eq(app_user_id)
    expect(metadata['original_app_user_id']).to eq(app_user_id)
    expect(metadata['type']).to eq('INITIAL_PURCHASE')
    expect(metadata['purchased_at_ms']).to eq(nil)
    expect(metadata['purchase_index']).to eq(0)
    if store == 'PLAY_STORE'
      expect(metadata['product_id']).to eq('assinatura_me_salva_ensino_medio')
      expect(metadata['transaction_id_old']).to \
        eq("GPA.#{app_user_id}_111111111#{transaction_id_seq}000")
    else
      expect(metadata['product_id']).to eq('assinatura_me_salva_enem_e_vestibulares')
      expect(metadata['transaction_id_old']).to \
        eq("#{app_user_id}_111111111#{transaction_id_seq}000")
    end
  end

  def subscription_renew_expects(original_transaction_id, renew_transaction_id, counts,
                                 store_transaction)
    expect(store_transaction.all.count).to eq(counts[:transaction])
    expect(store_transaction.first.transaction_id).to eq(original_transaction_id)
    expect(store_transaction.last.transaction_id).to eq(renew_transaction_id)
    expect(store_transaction.last.order_payment_id).to eq(OrderPayment.last.id)
    expect(Order.all.count - 1).to eq(counts[:order])
    expect(Order.last.status).to eq(2)
    expect(Order.last.broker).to eq(store.downcase)
    expect(Order.last.expires_at).to eq(Date.today + 30.days)
    expect(OrderPayment.all.count).to eq(counts[:order_payment])
    expect(OrderPayment.last.order_id).to eq(Order.last.id)
    expect(OrderPayment.last.amount_in_cents).to \
      eq(valid_params[:event]['price_in_purchased_currency'].to_i * 100)
    expect(Access.all.count).to eq(counts[:access])
    expect(Access.last.expires_at).to eq(Date.today + 30.days)
  end
  # rubocop:enable Metrics/AbcSize

  def transit_transaction(store_transaction)
    store_transaction.last.order_payment.order.state_machine.transition_to!(:paid)
    store_transaction.last.order_payment.order.accesses.last
                     .update(expires_at: Date.today + 30.days)
  end

  def app_user_id
    "$RCAnonymousID:h56t8i5jh90s8jnjrrjri99ewrkdzxc9"
  end
end

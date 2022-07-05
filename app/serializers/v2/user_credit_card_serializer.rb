# frozen_string_literal: true

class V2::UserCreditCardSerializer < V2::ApplicationSerializer
  attribute :brand,
            :expiration_date,
            :first_digits,
            :holder_name,
            :last_digits

  set_id :id

  attribute :valid do |object|
    if object.valid
      object.valid
    else
      false
    end
  end

  attribute :customer_id do |object|
    object.customer.id if object.customer.present?
  end
end

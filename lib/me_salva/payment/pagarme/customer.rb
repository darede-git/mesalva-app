# frozen_string_literal: true

module MeSalva
  module Payment
    module Pagarme
      class Customer < ActiveModelSerializers::Model
        attr_accessor :order, :billing_name

        def to_h
          return personal_data unless order.address

          personal_data
        end

        def personal_data
          birthday = DateHelper.valid_date_with_fallback(order.user.birth_date)
          { external_id: order.user.uid,
            type: 'individual',
            country: 'br',
            name: billing_name,
            documents: [{
              type: 'cpf',
              number: order.cpf
            }],
            email: order.email,
            birthday: birthday.to_s,
            phone_numbers: ["+55#{order.phone_area}#{order.phone_number}"] }
        end

        def billing_data
          { name: billing_name }.merge(address)
        end

        def shipping_data
          { name: billing_name,
            fee: order.price_paid.to_f,
            expedited: true,
            delivery_date: Date.today.to_s }.merge(address)
        end

        private

        def address
          { address: { country: 'br',
                       state: order.address.state,
                       city: order.address.city,
                       street: order.address.street,
                       neighborhood: order.address.neighborhood,
                       zipcode: order.address.zip_code.gsub("-", ""),
                       street_number: order.address.street_number.to_s,
                       complementary: order.address.street_detail } }
        end
      end
    end
  end
end

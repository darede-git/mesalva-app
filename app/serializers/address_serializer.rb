# frozen_string_literal: true

class AddressSerializer < ActiveModel::Serializer
  attributes :id,            :street,    :street_number, :street_detail,
             :neighborhood,  :city,      :zip_code,      :state,
             :country,       :area_code, :phone_number
end

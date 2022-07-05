# frozen_string_literal: true

class V2::AddressSerializer < V2::ApplicationSerializer
  attributes :street, :street_number, :street_detail, :neighborhood, :city,
             :zip_code, :state, :country, :area_code, :phone_number
end

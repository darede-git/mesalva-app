# frozen_string_literal: true

module AddressConcern
  extend ActiveSupport::Concern

  def address_attributes
    %i[street street_number street_detail neighborhood
       city zip_code state country]
  end
end

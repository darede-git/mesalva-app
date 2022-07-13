# frozen_string_literal: true

module DeliveryShippingAssertionHelper
  CHEAPEST_SERVICE_SEDEX = { service: 'SEDEX',
                             availability: true,
                             price: 14.04,
                             time_in_days: 5 }.freeze

  CHEAPEST_SERVICE_PAC = { service: 'PAC',
                           availability: true,
                           price: 22.70,
                           time_in_days: 9 }.freeze

  CHEAPEST_SERVICE_NONE = { service: 'NONE' }.freeze

  CHEAPEST_SERVICE_UF_RS = { service: 'SEDEX',
                             availability: true,
                             price: 44.04,
                             time_in_days: 5 }.freeze

  SERVICE_SEDEX = { service: 'SEDEX',
                    availability: true,
                    price: 14.04,
                    time_in_days: 5 }.freeze

  SERVICE_PAC = { service: 'PAC',
                  availability: true,
                  price: 22.70,
                  time_in_days: 9 }.freeze

  SERVICE_NONE = { service: 'NONE' }.freeze

  def assert_cheapest_service_sedex(result)
    expect(result).to eq(CHEAPEST_SERVICE_SEDEX)
  end

  def assert_cheapest_service_pac(result)
    expect(result).to eq(CHEAPEST_SERVICE_PAC)
  end

  def assert_cheapest_service_none(result)
    expect(result).to eq(CHEAPEST_SERVICE_NONE)
  end

  def assert_cheapest_service_uf_rs(result)
    expect(result).to eq(CHEAPEST_SERVICE_UF_RS)
  end

  def assert_service_sedex(result)
    expect(result).to eq(SERVICE_SEDEX)
  end

  def assert_service_pac(result)
    expect(result).to eq(SERVICE_PAC)
  end

  def assert_service_none(result)
    expect(result).to eq(SERVICE_NONE)
  end
end

# frozen_string_literal: true

module DeliveryTrackingAssertionHelper
  OBJECT_FOUND = { tracking_code: 'AB123456789BR',
                   message: 'OBJECT_FOUND',
                   events: [{ description: 'delivered',
                              date: '02/01/2022 08:00:00',
                              unity: 'unit_name',
                              city: 'city_name',
                              state: 'UF' },
                            { description: 'out for delivery',
                              date: '02/01/2022 07:00:00',
                              unity: 'unit_name',
                              city: 'city_name',
                              state: 'UF' },
                            { description: 'posted',
                              date: '01/01/2022 07:00:00',
                              unity: 'unit_name',
                              city: 'city_name',
                              state: 'UF' }] }.freeze

  OBJECT_NOT_FOUND = { tracking_code: 'AB999999999BR',
                       message: 'OBJECT_NOT_FOUND',
                       events: [] }.freeze

  OBJECT_POSTED = { tracking_code: 'AB123456789BR',
                    message: 'POST',
                    status: true,
                    event: { date: '01/01/2022 07:00:00',
                             unity: 'unit_name',
                             city: 'city_name',
                             state: 'UF' } }.freeze

  OBJECT_NOT_POSTED = { tracking_code: 'AB123456789BR',
                        message: 'POST',
                        status: false,
                        event: {} }.freeze

  OBJECT_OUT_FOR_DELIVERY = { tracking_code: 'AB123456789BR',
                              message: 'OUT_FOR_DELIVERY',
                              status: true,
                              event: { date: '02/01/2022 07:00:00',
                                       unity: 'unit_name',
                                       city: 'city_name',
                                       state: 'UF' } }.freeze

  OBJECT_NOT_OUT_FOR_DELIVERY = { tracking_code: 'AB123456789BR',
                                  message: 'OUT_FOR_DELIVERY',
                                  status: false,
                                  event: {} }.freeze

  OBJECT_DELIVERED = { tracking_code: 'AB123456789BR',
                       message: 'DELIVERED',
                       status: true,
                       event: { date: '02/01/2022 08:00:00',
                                unity: 'unit_name',
                                city: 'city_name',
                                state: 'UF' } }.freeze

  OBJECT_NOT_DELIVERED = { tracking_code: 'AB123456789BR',
                           message: 'DELIVERED',
                           status: false,
                           event: {} }.freeze

  def assert_events_tracking_code_found(result)
    expect(result).to eq(OBJECT_FOUND)
  end

  def assert_events_tracking_code_not_found(result)
    expect(result).to eq(OBJECT_NOT_FOUND)
  end

  def assert_posted(result)
    expect(result).to eq(OBJECT_POSTED)
  end

  def assert_not_posted(result)
    expect(result).to eq(OBJECT_NOT_POSTED)
  end

  def assert_out_for_delivery(result)
    expect(result).to eq(OBJECT_OUT_FOR_DELIVERY)
  end

  def assert_not_out_for_delivery(result)
    expect(result).to eq(OBJECT_NOT_OUT_FOR_DELIVERY)
  end

  def assert_delivered(result)
    expect(result).to eq(OBJECT_DELIVERED)
  end

  def assert_not_delivered(result)
    expect(result).to eq(OBJECT_NOT_DELIVERED)
  end
end

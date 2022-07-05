# frozen_string_literal: true

FactoryBot.define do
  factory :voucher do
    token 'LF12345678'
    user { create(:user) }
    order { create(:order) }
    active true
    campaign 'love_friday_2018'
  end
end

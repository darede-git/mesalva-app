# frozen_string_literal: true

FactoryBot.define do
  factory :bookshop_gift_package do
    active true
    bookshop_link 'https://loja.mesalva.com/livros-combo-enem-top'
    association :package, factory: :package_valid_with_price
    notified_at Date.yesterday
    need_coupon false
  end
end

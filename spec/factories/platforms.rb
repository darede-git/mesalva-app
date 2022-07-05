# frozen_string_literal: true

FactoryBot.define do
  factory :platform do
    name 'example platform'
    sequence :slug do |n|
      "example_slug_#{n}"
    end
    theme 'example theme'
    panel '{"some":"value"}'
    dedicated_essay true
    domain 'platform.ms'
    mail_grant_access ''
    mail_invite ''
    sequence :cnpj do |n|
      "99.999.999/#{n.to_s.rjust(4, '0')}-99"
    end
  end
end

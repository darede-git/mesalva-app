# frozen_string_literal: true

FactoryBot.define do
  factory :testimonial do
    text 'Com o Me Salva!, passem em Medicina!'
    created_by 'admin@mesalva.com'
    updated_by 'admin@mesalva.com'
    avatar 'data:image/jpeg;base64,iVBORw0KGgoAAAANSUhE"\
"UgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP4z8DwHwAFAAH/VscvDQAAAABJRU5ErkJggg=='
    education_segment_slug 'enem-semestral'
    user_name 'João da Silva'
    phone '+55 51 99999-9999'
    email 'joao.silva@mesalva.com'
    sts_authorization true
    marketing_authorization true
  end
end

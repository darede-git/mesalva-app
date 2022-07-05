# frozen_string_literal: true

FactoryBot.define do
  factory :sisu_weightings do
    institute 'INSTITUTO FEDERAL DE EDUCAÇÃO, CIÊNCIA E TECNOLOGIA DO CEARÁ'
    college 'Campus de Aracati'
    course 'CIÊNCIA DA COMPUTAÇÃO'
    shift 'Integral'
    cnat_weight 2.0
    chum_weight 1.0
    ling_weight 2.0
    mat_weight 2.0
    red_weight 2.0
    year '2021'
    semester '1'
  end
end

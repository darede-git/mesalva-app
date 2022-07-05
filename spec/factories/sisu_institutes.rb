# frozen_string_literal: true

FactoryBot.define do
  factory :sisu_institute do
    year '2021'
    ies 'CENTRO FEDERAL DE EDUCAÇÃO TECNOLÓGICA CELSO SUCKOW DA FONSECA'
    course 'ADMINISTRAÇÃO'
    grade 'Bacharelado'
    shift 'Noturno'
    modality 'Ampla Concorrência'
    passing_score '674,24'
    state 'RJ'
    initials 'CEFET/RJ'
    semester '1'
  end
end

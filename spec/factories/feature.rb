# frozen_string_literal: true

FactoryBot.define do
  factory :feature do
    sequence(:name) { |n| "Feature#{n}" }
    sequence(:slug) { |n| "feature#{n}" }

    trait :study_plan do
      name 'Plano de Estudos'
      slug 'plano-de-estudos'
      token 'study_plan'
    end

    trait :default_essay do
      name 'Redação Padrão'
      slug 'redacao-padrao'
      token 'default'
      category 'essay'
    end

    trait :custom_essay do
      name 'Redação Personalizada'
      slug 'redacao-personalizada'
      token 'premium'
      category 'essay'
    end

    trait :text_plan do
      name 'Plano de texto de redação'
      slug 'plano-de-texto-de-redacao'
      token 'text_plan'
      category 'essay'
    end

    trait :mentoring do
      name 'Mentorias'
      slug 'mentoria'
      token 'mentoring'
    end

    trait :private_class do
      name 'Aulas particulares'
      slug 'aula-particular'
      token 'private_class'
    end

    trait :books do
      name 'livros'
      slug 'livros'
      token 'books'
    end

    trait :unlimited_essay do
      name 'Redação Inlimitada'
      slug 'redacao-inlimitada'
      token 'unlimited'
      category 'essay'
    end

    trait :mentoring_credits do
      name 'Crédito de Mentorias'
      slug 'credito-de-mentorias'
      token 'limited'
      category 'mentoring'
    end
  end
end

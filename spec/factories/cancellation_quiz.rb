# frozen_string_literal: true

FactoryBot.define do
  factory :cancellation_quiz do
    association :user, factory: :user
    association :order, factory: :order
    quiz do
      {
        'answer1' => 'Entrei de férias',
        'answer2' => '6',
        'answer3' => '6',
        'question1' => 'Por que você optou por cancelar sua assinatura?',
        'question2' => 'Como você avalia sua experiência no Me Salva?',
        'question3' => 'Você recomendaria o Me Salva! para um amigo ou colega?'
      }
    end
  end
end

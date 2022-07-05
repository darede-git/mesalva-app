# frozen_string_literal: true

FactoryBot.define do
  factory :prep_test_detail do
    token "exemple token"
    weight 70
    suggestion_type "exemple suggestion_type"
    options do
      {
        'test1' => 'exemplo test 1',
        'test2' => 'exemplo test 2',
        'test3' => 'exemplo test 3',
        'test4' => 'exemplo test 4',
        'test5' => 'exemplo test 5',
        'test6' => 'exemplo test 6'
      }
    end
  end
end

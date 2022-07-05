# frozen_string_literal: true

FactoryBot.define do
  factory :prep_test_overview do
    user_uid "exemple user_uid"
    token "exemple token"
    score 40.78
    permalink_slug "exemple-permalink/slug"
    corrects 200
    answers do
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

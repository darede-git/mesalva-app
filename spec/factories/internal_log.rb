# frozen_string_literal: true

FactoryBot.define do
  factory :internal_log do
    factory :internal_log_message do
      log 'Example Message'
      category 'category_example'
      log_type 'Message'
    end
    factory :internal_log_statistic do
      log do
        { 'iterations' => 0,
          'users_found' => 0,
          'users_updated' => 0,
          'student_leads_found' => 0,
          'student_leads_updated' => 0,
          'subscribers_found' => 0,
          'subscribers_updated' => 0,
          'unsubscribers_found' => 0,
          'unsubscribers_updated' => 0,
          'ex_subscribers_found' => 0,
          'ex_subscribers_updated' => 0 }
      end
      category 'category_example'
      log_type 'Statistic'
    end
  end
end

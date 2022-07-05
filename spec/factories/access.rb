# frozen_string_literal: true

FactoryBot.define do
  factory :access do
    user { create(:user) }
    starts_at Time.now
    active true

    trait :one_month do
      starts_at Time.now - 1.minute
      expires_at Time.now + 1.month
    end

    factory :access_with_expires_at do
      package do
        create(:package_with_expires_at,
               expires_at: Time.now + 1.hour,
               node_ids: [Node.last.id])
      end
      order do
        create(:order_with_expiration_date,
               package_id: package.id,
               user_id: user.id)
      end
      expires_at { package.expires_at }
    end

    factory :access_with_duration do
      package do
        create(:package_with_duration,
               node_ids: [Node.last.id])
      end
      order do
        create(:order_with_expiration_date,
               package_id: package.id,
               user_id: user.id)
      end
      expires_at { Time.now + package.duration_in_months }
    end

    factory :access_expiring_today do
      user do
        create(:user)
      end
      package do
        create(:package_with_expires_at,
               expires_at: Time.now,
               node_ids: [create(:node).id])
      end
      order do
        create(:order_with_expiration_date,
               package_id: package.id,
               user_id: user.id)
      end
      expires_at { package.expires_at }
    end

    factory :access_expiring_tomorow do
      user do
        create(:user)
      end
      package do
        create(:package_with_expires_at,
               expires_at: Time.now + 1.day,
               node_ids: [create(:node).id])
      end
      order do
        create(:order_with_expiration_date,
               package_id: package.id,
               user_id: user.id)
      end
      expires_at { package.expires_at }
    end

    factory :access_expired do
      user do
        create(:user)
      end
      package do
        create(:package_with_expires_at,
               expires_at: Time.now - 1.day,
               node_ids: [create(:node).id])
      end
      order do
        create(:expired_status_order)
      end
      expires_at { package.expires_at }
    end

    factory :valid_access_with_refunded_order do
      user do
        create(:user)
      end
      package do
        create(:package_with_expires_at,
               expires_at: Time.now + 1.day,
               node_ids: [create(:node).id])
      end
      order do
        create(:refunded_order)
      end
      expires_at { package.expires_at }
    end

    factory :expired_access_with_refunded_order do
      user do
        create(:user)
      end
      package do
        create(:package_with_expires_at,
               expires_at: Time.now - 1.day,
               node_ids: [create(:node).id])
      end
      order do
        create(:refunded_order)
      end
      expires_at { package.expires_at }
    end

    # factory :access_expiring_tomorow do
    #   create(:access_expiring_today, expires_at: Date.today + 1.day)
    # end

    factory :access_with_duration_and_node do
      package do
        create(:package_with_duration,
               node_ids: [create(:node_area).id])
      end
      order do
        create(:order_with_expiration_date,
               package_id: package.id,
               user_id: user.id)
      end
      expires_at { Time.now + package.duration_in_months }
    end

    factory :access_with_subscription do
      package do
        create(:package_subscription,
               node_ids: [Node.last.id])
      end
      order do
        create(:subscription_order,
               package_id: package.id,
               user_id: user.id)
      end
      expires_at { order.expires_at }
    end

    factory :gift_access_with_duration do
      package do
        create(:package_with_expires_at)
      end
      order nil
      expires_at { package.expires_at }
      gift true
    end
  end
end

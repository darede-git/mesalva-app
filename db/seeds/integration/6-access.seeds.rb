# frozen_string_literal: true
Access.create(user_id: 1,
              package_id: 2380,
              order_id: 3,
              starts_at: Time.now - 5.days,
              expires_at: Time.now + 5.days)

Access.create(user_id: User.find_by_email('thu@co.com').id,
              package_id: 2380,
              order_id: 3,
              starts_at: Time.now - 5.days,
              expires_at: Time.now + 5.days)

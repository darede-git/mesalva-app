# frozen_string_literal: true

notification = FactoryBot.create(:notification, user_id: 1)

notification_event = FactoryBot.create(:notification_event,
                                       user_id: 1,
                                       notification: notification)
# frozen_string_literal: true

class UserState
  include Statesman::Machine
  extend IntercomHelper

  state :undefined, initial: true
  state :student_lead
  state :subscriber
  state :unsubscriber
  state :ex_subscriber

  transition from: :undefined, to: %i[student_lead
                                      subscriber
                                      unsubscriber
                                      ex_subscriber]

  transition from: :student_lead, to: %i[student_lead
                                         subscriber
                                         unsubscriber
                                         ex_subscriber]

  transition from: :subscriber, to: %i[student_lead
                                       subscriber
                                       unsubscriber
                                       ex_subscriber]

  transition from: :unsubscriber, to: %i[student_lead
                                         subscriber
                                         unsubscriber
                                         ex_subscriber]

  transition from: :ex_subscriber, to: %i[student_lead
                                          subscriber
                                          unsubscriber
                                          ex_subscriber]

  after_transition do |user, transition|
    update_intercom_user(user, subscriber: user.premium_status)
    user.save_status_with_string(transition.to_state)
  end
end

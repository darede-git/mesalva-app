# frozen_string_literal: true

module UserAccessSpecHelper
  def access_create(order)
    subject.create(order.user, order.package, order: order)
  end

  def contest_access(order)
    subject.contest(order)
  end

  def create_gift(user, package, months, admin)
    subject.create(user, package, duration: months, admin: admin, gift: true)
  end

  def validate_access(permalink, user)
    permalink_access = MeSalva::Permalinks::Access.new
    permalink_access.validate(permalink.node_ids, user)
  end

  def reset_time
    Timecop.return
  end

  def sum_of(entities, method)
    entities[0] = entities.first.public_send(method)
    entities.inject do |sum, n|
      sum + n
    end
  end

  def remaining_days_for(access)
    ((access.expires_at - Time.now).to_i / 1.day) + 1
  end

  def subscription_extra_time
    3.days
  end

  def user_state_transition_asserts(user, state)
    transition = user.user_transitions.last
    expect(transition).not_to eq(nil)
    expect(transition.to_state).to eq(state.to_s)
    expect(user.premium_status).to eq(::User::PREMIUM_STATUS[state])
  end
end

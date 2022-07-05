# frozen_string_literal: true

require 'rails_helper'
RSpec.describe UserState, type: :model do
  let(:status) do
    { student_lead: 0,
      subscriber: 1,
      unsubscriber: 2,
      ex_subscriber: 3 }
  end

  describe 'after_transition' do
    it 'should updated order status with same state' do
      user.state_machine.transition_to(:subscriber)
      expect(user.premium_status).to eq(status[:subscriber])
    end
  end

  describe 'after_transition to student_lead' do
    it 'updates user status on intercom' do
      user.state_machine.transition_to(:student_lead)
      expect(user.premium_status).to eq(status[:student_lead])
      expect(user.user_transitions.last.user).to eq(user)
      expect(user.user_transitions.last.to_state).to eq('student_lead')
    end
  end

  describe 'after_transition to subscriber' do
    it 'updates user status on intercom' do
      user.state_machine.transition_to(:subscriber)
      expect(user.premium_status).to eq(status[:subscriber])
      expect(user.user_transitions.last.user).to eq(user)
      expect(user.user_transitions.last.to_state).to eq('subscriber')
    end
  end

  describe 'after_transition to unsubscriber' do
    it 'updates user status on intercom' do
      user.state_machine.transition_to(:unsubscriber)
      expect(user.premium_status).to eq(status[:unsubscriber])
      expect(user.user_transitions.last.user).to eq(user)
      expect(user.user_transitions.last.to_state).to eq('unsubscriber')
    end
  end

  describe 'after_transition to ex_subscriber' do
    it 'updates user status on intercom' do
      user.state_machine.transition_to(:ex_subscriber)
      expect(user.premium_status).to eq(status[:ex_subscriber])
      expect(user.user_transitions.last.user).to eq(user)
      expect(user.user_transitions.last.to_state).to eq('ex_subscriber')
    end
  end
end

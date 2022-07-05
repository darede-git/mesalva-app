# frozen_string_literal: true

class UserTransition < ActiveRecord::Base
  include Statesman::Adapters::ActiveRecordTransition

  validates :to_state, inclusion: { in: UserState.states }

  belongs_to :user, inverse_of: :user_transitions
end

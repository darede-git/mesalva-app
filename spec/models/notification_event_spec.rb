# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotificationEvent, type: :model do
  context 'validations' do
    it { should belong_to(:notification) }
    it { should validate_presence_of(:notification_id) }
    it { should validate_inclusion_of(:read).in?([true, false]) }
  end
end

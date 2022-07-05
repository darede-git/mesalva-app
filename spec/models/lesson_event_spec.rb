# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LessonEvent, type: :model do
  context 'validations' do
    should_be_present(:user)
    should_be_present(:node_module_slug)
  end
end

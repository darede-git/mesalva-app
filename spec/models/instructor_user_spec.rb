# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InstructorUser, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:instructor) }
end

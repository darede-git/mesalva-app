# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PagarmeSubscription, type: :model do
  it_should_behave_like 'validations', %w[subscription]
end

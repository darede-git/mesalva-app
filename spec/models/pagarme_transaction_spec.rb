# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PagarmeTransaction, type: :model do
  it_should_behave_like 'transaction'
end

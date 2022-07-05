# frozen_string_literal: true

RSpec.shared_examples 'transaction' do
  context 'validations' do
    should_be_present(:transaction_id)
    it { should validate_uniqueness_of :transaction_id }
  end
end

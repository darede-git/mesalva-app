# frozen_string_literal: true

RSpec.shared_examples 'validations' do |entity|
  context 'validations' do
    should_belong_to(entity.first.to_sym)

    should_be_present(:pagarme_id)
    it { should validate_uniqueness_of :pagarme_id }
  end
end

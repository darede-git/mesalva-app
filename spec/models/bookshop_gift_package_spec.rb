# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BookshopGiftPackage, type: :model do
  context 'validations' do
    it { should have_many(:bookshop_gifts) }
    it { should validate_acceptance_of(:active) }
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LpPage, type: :model do
  context 'validations' do
    should_be_present(:name, :data, :schema)
  end
  context 'on save' do
    it 'should create slug based on name' do
      lp_page = create(:lp_page, name: 'ENEM')
      expect(lp_page.slug).not_to be nil
      expect(lp_page.slug).to eq 'enem'
    end
  end
end

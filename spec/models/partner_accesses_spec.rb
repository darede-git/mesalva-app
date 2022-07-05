# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PartnerAccess, type: :model do
  context 'validations' do
    it { should validate_presence_of(:cpf) }
    it { should validate_presence_of(:birth_date) }
    it { should validate_presence_of(:partner) }
    it { should belong_to(:user) }
  end
end

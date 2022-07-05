# frozen_string_literal: true

require "rails_helper"

RSpec.describe MeSalva::Billing::StudentLoan do
  let(:package) { create(:package_valid_with_price) }
  let(:user) { create(:user) }
  let(:order_attributes) do
    attributes_for(:order,
                   package_id: package.id,
                   broker: 'koin',
                   price_paid: 1000)
  end

  subject { described_class.new(order_attributes, user.uid) }

  describe '#created_student_loan' do
    it "criando uma order" do
      expect { subject.created_student_loan }.to change(Order, :count)
        .by(1).and change(Access, :count).by(1)
      created_order = Order.first
      created_access = Access.first
      expect(created_order.price_paid).to eq(1000)
      expect(created_order.user_id).to eq(user.id)
      expect(created_order.package_id).to eq(package.id)
      expect(created_order.broker).to eq('koin')
      expect(created_order.checkout_method).to eq('bank_slip')
      expect(created_order.status).to eq(2)
      expect(created_access.user_id).to eq(user.id)
      expect(created_access[:order_id]).to eq(created_order.id)
      expect(created_access.package_id).to eq(package.id)
      expect(created_access.expires_at.to_date).to \
        eq((Date.today + package.duration.months).to_date)
      expect(created_access.active).to eq(true)
    end
  end
end

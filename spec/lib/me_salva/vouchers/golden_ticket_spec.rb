# frozen_string_literal: true

require 'rails_helper'
require 'me_salva/vouchers/golden_ticket'

RSpec.describe MeSalva::Vouchers::GoldenTicket do
  let(:platform) { create(:platform) }
  let(:package) { create(:package_valid_with_price) }
  let(:duration) { 120 }
  let(:quantity) { 4 }
  describe 'initialize lib' do
    let(:valid_initialize) do
      {
        "package_id" => package.id,
        "duration" => duration,
        "platform" => platform,
        "created" => []
      }
    end
    context 'with valid params' do
      let(:users) do
        [
          { "email": 'user1@email.com', "platform_slug": platform.slug },
          { "email": 'user2@email.com', "platform_slug": platform.slug },
          { "email": 'user3@email.com', "platform_slug": platform.slug }
        ]
      end
      let(:initialized_lib) { described_class.new(platform.slug, package.id, duration) }

      it 'set platform based on platform slug, and have custom package and duration' do
        expect(initialized_lib.instance_values).to eq(valid_initialize)
      end

      context '#create_by_users' do
        it 'create voucher through email' do
          expect do
            initialized_lib.create_by_users(users)
          end.to change(PlatformVoucher, :count).by(3)
          expect(PlatformVoucher.last(3).pluck(:platform_id).uniq).to eq([platform.id])
        end
      end

      context '#create_by_quantity' do
        it "create vouchers through quantity" do
          expect do
            initialized_lib.create_by_quantity(quantity)
          end.to change(PlatformVoucher, :count).by(quantity)
          expect(PlatformVoucher.last(3).pluck(:platform_id).uniq).to eq([platform.id])
        end
      end
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'updateable_field' do |field|
  let(:new_platform_slug) { create(:platform).slug }
  let(:duration) { 120 }
  let(:email) { 'novo+email@xpto.com' }
  before { user_platform_admin_session }

  it 'updates succeffuly and return status ok' do
    updateable_fields = { token: unused_platform_voucher.token,
                          platform_slug: user_platform_admin.platform.slug, field => send(field) }

    post :update, params: updateable_fields
    assert_apiv2_response(:ok, unused_platform_voucher.reload,
                          V2::PlatformVoucherSerializer, %i[package platform user])
  end
end

RSpec.describe PlatformVouchersController, type: :controller do
  let(:package) { create(:package_valid_with_price) }
  let(:users) do
    [
      { "email": 'user1@email.com' },
      { "email": 'user2@email.com' },
      { "email": 'user3@email.com' }
    ]
  end
  let(:unused_platform_voucher) do
    create(:platform_voucher, user_id: nil, platform: user_platform.platform)
  end
  let(:consumed_platform_voucher) { create(:platform_voucher, :already_in_use) }
  let(:voucher_with_email) do
    create(:platform_voucher, platform: user_platform.platform, email: "e@mail.com")
  end
  let(:voucher_with_duration) do
    create(:platform_voucher, platform: user_platform.platform, duration: 60)
  end

  describe '#get' do
    before { user_platform_admin_session }
    let(:platform) { create(:platform) }
    context 'valid params' do
      it 'creates through emails with different platform_slug' do
        expect do
          post :create_many, params: { users: users,
                                       package_id: package.id, platform_slug: platform.slug }
        end.to change(PlatformVoucher, :count).by(3)
        expect(response).to have_http_status(:created)
        expect(parsed_response
        .map { |golden_ticket| golden_ticket[:platform_id] != user_platform_admin.id })
          .to eq [true, true, true]
      end
      it 'creates through quantity with' do
        expect do
          post :create_many, params: { quantity: 4, package_id: package.id,
                                       platform_slug: user_platform_admin.platform.slug }
        end.to change(PlatformVoucher, :count).by(4)
        expect(response).to have_http_status(:created)
        expect(PlatformVoucher.last(4)
        .map { |golden_ticket| golden_ticket[:platform_id] == user_platform_admin.platform.id })
          .to eq [true, true, true, true]
      end
    end
  end

  describe '#rescue' do
    let(:platform) { create(:platform) }
    let(:platform_voucher) { create(:platform_voucher, platform_id: platform.id) }
    let(:platform_voucher_with_email) do
      create(:platform_voucher, platform_id: platform.id, email: user.email)
    end
    let(:platform_voucher_already_used) do
      create(:platform_voucher, :already_in_use, platform_id: platform.id)
    end
    context 'valid params' do
      before { user_session }
      it 'rescue through token' do
        expect do
          put :rescue, params: { token: platform_voucher.token }
          platform_voucher.reload
        end.to change(UserPlatform, :count).to eq(1)
        expect(response).to have_http_status(:created)
        platform_voucher.reload
        expect(platform_voucher.user_id).to eq(user.id)
        expect(Access.find_by(user_id: user.id)).not_to be_nil
      end

      before { platform_voucher_with_email }
      it 'rescue through email' do
        expect do
          put :rescue
        end.to change(UserPlatform, :count).to eq(1)
        expect(response).to have_http_status(:created)
        platform_voucher_with_email.reload
        expect(platform_voucher_with_email.user_id).to eq(user.id)
        expect(Access.find_by(user_id: user.id)).not_to be_nil
      end
    end

    context 'invalid params' do
      context 'token already in use' do
        it 'returns unauthorized status' do
          unauthorized_request(token: platform_voucher_already_used.token)
        end
      end

      context 'email not found in platform vouchers' do
        before { authentication_headers_for(platform_voucher_already_used.user) }
        it 'returns unauthorized status' do
          unauthorized_request
        end
      end
    end
  end

  def unauthorized_request(**params)
    expect(put(:rescue, params: { token: params[:token] })).to have_http_status(:unauthorized)
  end
end

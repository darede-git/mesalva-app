# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DiscountsController, type: :controller do
  include ContentStructureAssertionHelper

  let(:valid_attributes) do
    FactoryBot.attributes_for(:discount)
  end
  let(:invalid_attributes) do
    FactoryBot.attributes_for(:discount, percentual: nil)
  end
  let!(:package) { create(:package_valid_with_price) }
  let!(:discount) { create(:discount, packages: [package.id.to_s]) }

  describe 'POST #create' do
    context 'as admin' do
      before { admin_session }
      context 'with valid params' do
        it 'creates a new Discount' do
          expect do
            post :create, params: valid_attributes
          end.to change(Discount, :count).by(1)

          assert_jsonapi_response(:created, Discount.last, DiscountSerializer)
          assert_created_by(Discount.last, admin)
        end
      end

      context 'with invalid params' do
        it 'returns http unprocessable_entity' do
          post :create, params: invalid_attributes

          assert_type_and_status(:unprocessable_entity)
        end
      end
    end

    context 'as user' do
      before { user_session }
      it 'returns http unauthorized' do
        post :create, params: { discount: valid_attributes }

        assert_type_and_status(:unauthorized)
      end
    end
  end

  describe 'PUT #update' do
    context 'as admin' do
      before { admin_session }
      context 'with valid params' do
        it 'updates the requested discount' do
          expect do
            put :update, params: { id: discount.token,
                                   description: 'new description',
                                   only_customer: true }
          end.to(change { discount.reload.description })

          expect(Discount.last.only_customer).to eq(true)
          assert_jsonapi_response(:ok, discount, DiscountSerializer)
          assert_updated_by(discount, admin)
        end
      end

      context 'with invalid params' do
        before { admin_session }
        context 'with valid discount token' do
          it 'returns http code 422 unprocessable_entity' do
            put :update, params: { id: discount.token, expires_at: nil }

            assert_type_and_status(:unprocessable_entity)
          end
        end
        context 'with invalid discount token' do
          it 'returns http status 404 not_found' do
            put :update, params: { id: 'invalid token' }

            assert_type_and_status(:not_found)
          end
        end
      end
    end

    context 'as user' do
      before { user_session }
      it 'returns http unauthorized' do
        put :update, params: { id: discount.token,
                               description: 'new description' }

        assert_type_and_status(:unauthorized)
      end
    end
  end

  describe 'GET #show' do
    context 'as admin' do
      before { admin_session }
      context 'with valid params' do
        it 'returns discount' do
          get :show, params: { id: discount.token }

          assert_jsonapi_response(:ok, discount, DiscountSerializer)
        end
      end

      context 'with invalid params' do
        it 'returns http code 404 not_found' do
          get :show, params: { id: 'invalid_token' }
          assert_type_and_status(:not_found)
        end
      end
    end

    context 'as  user' do
      before { user_session }
      it 'returns http unauthorized' do
        get :show, params: { id: discount.token }
        assert_type_and_status(:unauthorized)
      end
    end
  end

  describe 'POST #redeem' do
    context 'as admin' do
      before { admin_session }
      it 'returns http unauthorized' do
        post :redeem, params: { code: discount.code,
                                package_slug: package.slug }

        assert_type_and_status(:unauthorized)
      end
    end

    context 'as  user' do
      before { user_session }
      context 'with valid params' do
        context 'for a regular client' do
          it 'returns discount' do
            post :redeem, params: { code: discount.code,
                                    package_slug: package.slug }

            assert_jsonapi_response(:ok, discount, DiscountSerializer)
          end
        end
      end

      context 'with valid params' do
        context 'for a only_costumer client' do
          let!(:discount_only_customer) do
            create(:discount_only_customer, packages: [package.id])
          end
          context 'within the only costumer valid period' do
            context 'with a valid access' do
              let!(:access) do
                create(:access_with_duration,
                       expires_at: Date.today + 30.days,
                       package: package,
                       user_id: user.id)
              end
              it 'returns discount for only_costumer' do
                post :redeem, params: { code: discount_only_customer.code,
                                        package_slug: package.slug }

                assert_jsonapi_response(:ok, discount_only_customer, DiscountSerializer)
              end
            end
            context 'with a expired access' do
              let!(:access) do
                create(:access_with_duration,
                       expires_at: Date.today - 15.days,
                       package: package,
                       user_id: user.id)
              end
              it 'returns discount for only_costumer' do
                post :redeem, params: { code: discount_only_customer.code,
                                        package_slug: package.slug }

                assert_jsonapi_response(:ok, discount_only_customer, DiscountSerializer)
              end
            end
          end
          context 'with access out of only costumer rule range' do
            context 'before the last 30 days of access' do
              let!(:access) do
                create(:access_with_duration,
                       expires_at: Date.today + 31.days,
                       package: package,
                       user_id: user.id)
              end
              it 'returns discount for only_costumer' do
                post :redeem, params: { code: discount_only_customer.code,
                                        package_slug: package.slug }

                assert_type_and_status(:unprocessable_entity)
              end
            end
            context 'after the first 15 days of expired access' do
              let!(:access) do
                create(:access_with_duration,
                       expires_at: Date.today - 16.days,
                       package: package,
                       user_id: user.id)
              end
              it 'returns discount for only_costumer' do
                post :redeem, params: { code: discount_only_customer.code,
                                        package_slug: package.slug }

                assert_type_and_status(:unprocessable_entity)
              end
            end
          end
        end
      end

      context 'with invalid params' do
        context 'without valid package_slug' do
          it 'returns http code 422 unprocessable_entity' do
            post :redeem, params: { code: discount.code,
                                    package_slug: 'invalid_slug' }
            assert_type_and_status(:unprocessable_entity)
          end
        end

        context 'without valid code' do
          it 'returns http code 422 unprocessable_entity' do
            post :redeem, params: { code: 'invalid_code',
                                    package_slug: package.slug }
            assert_type_and_status(:unprocessable_entity)
          end
        end
      end
    end
  end
end

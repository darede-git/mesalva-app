# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  let!(:package) { create(:package_valid_with_price) }
  let!(:user2) { create(:user) }
  let!(:admin) { create(:admin) }

  let!(:order1) do
    create(
      :order_valid,
      package_id: package.id,
      user_id: user.id
    )
  end
  let!(:order2) do
    create(
      :order_valid,
      package_id: package.id,
      user_id: user2.id,
      checkout_method: 'credit_card'
    )
  end

  let(:address_attributes) do
    { 'address_attributes': {
      'city': 'Porto Alegre', 'zip_code': '91920-000', 'state': 'RS',
      'street_number': 79, 'neighborhood': 'Moinhos de Vento'
    } }
  end

  describe 'POST #create' do
    context 'as an user' do
      context 'with valid attributes' do
        let(:new_order_attributes) do
          {
            broker_product_id: 'assinatura_me_salva_engenharia',
            amount_in_cents: '1000',
            currency: 'BRL'
          }
        end

        context 'as android request' do
          it 'returns a new user order as serializer' do
            user_session
            post :create, params: new_order_attributes
              .merge(broker: 'play_store')
              .merge(broker_data: android_data)

            assert_jsonapi_response(:created,         Order.last,
                                    OrderSerializer,  :package)
            expect(Order.last.status).to eq(2)
            expect(Order.last.broker_data).not_to be_nil
            expect(Order.last.broker_invoice).to eq(android_data[:orderId])
            expect(Order.last.price_paid).to eq(10)
          end
        end

        context 'as ios request' do
          before do
            user_session
            post :create, params: new_order_attributes
              .merge(broker: 'app_store')
              .merge(broker_data: ios_data)
          end

          it 'returns a new user order as serializer' do
            assert_jsonapi_response(:created,         Order.last,
                                    OrderSerializer,  :package)
            expect(Order.last.status).to eq(2)
            expect(Order.last.broker_data).not_to be_nil
            expect(Order.last.broker_invoice)
              .to eq(ios_data[:transaction_id].to_s)
            expect(Order.last.price_paid).to eq(10)
          end

          context 'when duplicated request' do
            it 'should return respective order' do
              expect do
                post :create, params: new_order_attributes
                  .merge(broker: 'app_store')
                  .merge(broker_data: ios_data)
              end.to change(Order, :count).by(0)

              assert_jsonapi_response(:created,         Order.last,
                                      OrderSerializer,  :package)
            end
          end
        end
      end

      context 'with invalid package' do
        let(:invalid_attributes) do
          { broker_product_id: 'assinatura_me_salva_engenharia',
            broker: 'play_store',
            email: 'user@google_play.com',
            amount_in_cents: '1000',
            price_paid: '100' }
        end
        it 'returns unproccessable entity' do
          user_session
          post :create, params: invalid_attributes

          assert_type_and_status(:unprocessable_entity)
        end
      end

      context 'with invalid expires_at' do
        before do
          user_session
          expect(NewRelic::Agent).to receive(:notice_error).and_return(nil)
        end

        let!(:invalid_attributes) do
          base_attributes
            .merge!(address_attributes)
            .merge!(broker_data: android_data.except(:purchaseTime))
        end

        it 'returns unproccessable entity' do
          user_session
          post :create, params: invalid_attributes
            .merge(broker_data: android_data.except(:purchaseTime))

          assert_type_and_status(:unprocessable_entity)
        end
      end
    end
  end

  describe 'PUT #update' do
    let(:updatable_attributes) do
      { cpf: '123.456.789-01', email: 'order@email.com' }
    end

    let(:not_updatable_attributes) do
      { currency: 'Invalid', price_paid: '123456' }
    end

    let!(:request_attributes) do
      { id: order1.token,
        broker: 'play_store' }
        .merge(updatable_attributes)
        .merge(not_updatable_attributes)
        .merge(address_attributes)
    end

    context 'user owns the order' do
      before { user_session }
      context 'order exists' do
        it 'updates authorized attributes' do
          put :update, params: request_attributes

          assert_updatable_attributes(updatable_attributes, order1.reload)
          assert_updatable_attributes(address_attributes[:address_attributes],
                                      order1.address)
          assert_not_updatable_attributes(not_updatable_attributes, order1)
        end
      end

      context 'order does not exists' do
        it 'returns http status not_found' do
          put :update, params: { id: 'n0Tf0Und' }

          assert_type_and_status(:not_found)
        end
      end
    end

    context 'user does not owns the order' do
      context 'with user session' do
        it 'returns http status 401' do
          put :update, params: request_attributes

          assert_type_and_status(:unauthorized)
        end
      end

      context 'without user session' do
        it 'returns http status 401' do
          put :update, params: request_attributes

          assert_type_and_status(:unauthorized)
        end
      end

      context 'update order to pre_approved_status' do
        before { admin_session }
        let(:order) { create(:order_valid, package_id: package.id, user_id: user.id) }

        it 'admin updates succeffuly' do
          authentication_headers_for(admin)
          put :update, params: { id: order.token, payment_proof: order.payment_proof, status: 8 }
          expect(parsed_response['data']['attributes']['status']).to eq("pre_approved")
        end

        it 'user get error' do
          authentication_headers_for(user)
          put :update, params: { id: order.token, payment_proof: order.payment_proof, status: 8 }
          expect(response.status).to eq(422)
        end
      end
    end
  end

  describe 'GET #index' do
    context 'as user' do
      before { user_session }
      context 'without bookshop gifts' do
        context 'without complementary packages' do
          it 'returns user order as serializer' do
            get :index

            assert_jsonapi_response(:success, [order1], OrderSerializer, [:package])
            bookshop_gift = parsed_response["data"].first["attributes"]["bookshop-gifts"]
            expect(bookshop_gift).to eq([])
          end
        end
        context 'with a complementary package and a bookshop gift for the complementary package' do
          let!(:child_package) { create(:package_valid_with_price) }
          let!(:complementary_package) do
            create(:complementary_package,
                   package_id: package.id,
                   child_package_id: child_package.id)
          end
          let!(:bookshop_gift_package_complementary) do
            create(:bookshop_gift_package, package: child_package)
          end
          let!(:bookshop_gift_complementary) do
            create(:bookshop_gift,
                   :available,
                   coupon: '12345_complementary',
                   bookshop_gift_package: bookshop_gift_package_complementary)
          end
          before { order1.update(complementary_package_ids: [child_package.id]) }
          it 'returns user order as serializer' do
            get :index

            assert_jsonapi_response(:success, [order1], OrderSerializer, [:package])
            bookshop_gift = parsed_response["data"].first["attributes"]["bookshop-gifts"]
            expect(bookshop_gift).to eq([{ "coupon" => "12345_complementary",
                                           "coupon-available" => true }])
          end
        end
      end
      context 'with one bookshop gift for the main package' do
        context 'without complementary packages' do
          let!(:bookshop_gift_package) { create(:bookshop_gift_package, package: package) }
          let!(:bookshop_gift) do
            create(:bookshop_gift, :available, bookshop_gift_package: bookshop_gift_package)
          end
          it 'returns user order as serializer with one bookshop gift information' do
            get :index

            assert_jsonapi_response(:success, [order1], OrderSerializer, [:package])
            bookshop_gift = parsed_response["data"].first["attributes"]["bookshop-gifts"]
            expect(bookshop_gift).to eq([{ "coupon" => "12345",
                                           "coupon-available" => true }])
          end
        end
        context 'with a complementary package and a bookshop gift for the complementary package' do
          let!(:bookshop_gift_package) { create(:bookshop_gift_package, package: package) }
          let!(:bookshop_gift) do
            create(:bookshop_gift, :available, bookshop_gift_package: bookshop_gift_package)
          end
          let!(:child_package) { create(:package_valid_with_price) }
          let!(:complementary_package) do
            create(:complementary_package,
                   package_id: package.id,
                   child_package_id: child_package.id)
          end
          let!(:bookshop_gift_package_complementary) do
            create(:bookshop_gift_package, package: child_package)
          end
          let!(:bookshop_gift_complementary) do
            create(:bookshop_gift,
                   :available,
                   coupon: '12345_complementary',
                   bookshop_gift_package: bookshop_gift_package_complementary)
          end
          before { order1.update(complementary_package_ids: [child_package.id]) }
          it 'returns user order as serializer with one bookshop gift information' do
            get :index

            assert_jsonapi_response(:success, [order1], OrderSerializer, [:package])
            bookshop_gift = parsed_response["data"].first["attributes"]["bookshop-gifts"]
            expect(bookshop_gift).to eq([{ "coupon" => "12345",
                                           "coupon-available" => true },
                                         { "coupon" => "12345_complementary",
                                           "coupon-available" => true }])
          end
        end
      end
      context 'with multiple bookshop gifts' do
        context 'without complementary packages' do
          let!(:bookshop_gift_package1) { create(:bookshop_gift_package, package: package) }
          let!(:bookshop_gift_package2) { create(:bookshop_gift_package, package: package) }
          let!(:bookshop_gift1) do
            create(:bookshop_gift, :available, bookshop_gift_package: bookshop_gift_package1)
          end
          let!(:bookshop_gift2) do
            create(:bookshop_gift,
                   :to_be_available,
                   coupon: 'coupon-example',
                   bookshop_gift_package: bookshop_gift_package2)
          end
          it 'returns user order as serializer with multiple bookshop gift information' do
            get :index

            assert_jsonapi_response(:success, [order1], OrderSerializer, [:package])
            bookshop_gift = parsed_response["data"].first["attributes"]["bookshop-gifts"]
            expect(bookshop_gift).to eq([{ "coupon" => "12345",
                                           "coupon-available" => true },
                                         { "coupon" => "coupon-example",
                                           "coupon-available" => false }])
          end
        end
        context 'with complementary packages and bookshop gifts for the complementary packages' do
          let!(:bookshop_gift_package1) { create(:bookshop_gift_package, package: package) }
          let!(:bookshop_gift_package2) { create(:bookshop_gift_package, package: package) }
          let!(:bookshop_gift1) do
            create(:bookshop_gift, :available, bookshop_gift_package: bookshop_gift_package1)
          end
          let!(:bookshop_gift2) do
            create(:bookshop_gift,
                   :to_be_available,
                   coupon: 'coupon-example',
                   bookshop_gift_package: bookshop_gift_package2)
          end
          let!(:child_package1) { create(:package_valid_with_price) }
          let!(:child_package2) { create(:package_valid_with_price) }
          let!(:complementary_package1) do
            create(:complementary_package,
                   package_id: package.id,
                   child_package_id: child_package1.id)
          end
          let!(:complementary_package2) do
            create(:complementary_package,
                   package_id: package.id,
                   child_package_id: child_package2.id)
          end
          let!(:bookshop_gift_package_complementary1) do
            create(:bookshop_gift_package, package: child_package1)
          end
          let!(:bookshop_gift_complementary1) do
            create(:bookshop_gift,
                   :available,
                   coupon: '12345_complementary1',
                   bookshop_gift_package: bookshop_gift_package_complementary1)
          end
          let!(:bookshop_gift_package_complementary2) do
            create(:bookshop_gift_package, package: child_package2)
          end
          let!(:bookshop_gift_complementary2) do
            create(:bookshop_gift,
                   :available,
                   coupon: '12345_complementary2',
                   bookshop_gift_package: bookshop_gift_package_complementary2)
          end
          before do
            order1.update(complementary_package_ids: [child_package1.id, child_package2.id])
          end
          it 'returns user order as serializer with multiple bookshop gift information' do
            get :index

            assert_jsonapi_response(:success, [order1], OrderSerializer, [:package])
            bookshop_gift = parsed_response["data"].first["attributes"]["bookshop-gifts"]
            expect(bookshop_gift).to eq([{ "coupon" => "12345",
                                           "coupon-available" => true },
                                         { "coupon" => "coupon-example",
                                           "coupon-available" => false },
                                         { "coupon" => "12345_complementary1",
                                           "coupon-available" => true },
                                         { "coupon" => "12345_complementary2",
                                           "coupon-available" => true }])
          end
        end
      end
    end

    context 'as admin' do
      before { admin_session }
      it 'returns a list of orders filtered by user_iud' do
        get :index, params: { user_uid: user.uid }

        assert_jsonapi_response(:success, [order1], OrderSerializer, [:package])
        bookshop_gift = parsed_response["data"].first["attributes"]["bookshop-gifts"]
        expect(bookshop_gift).to eq([])
      end
      context 'with one bookshop gift' do
        let!(:bookshop_gift_package) { create(:bookshop_gift_package, package: package) }
        let!(:bookshop_gift) do
          create(:bookshop_gift, :available, bookshop_gift_package: bookshop_gift_package)
        end
        it 'returns a list of orders filtered by user_iud with one bookshop gift information' do
          get :index, params: { user_uid: user.uid }

          assert_jsonapi_response(:success, [order1], OrderSerializer, [:package])
          bookshop_gift = parsed_response["data"].first["attributes"]["bookshop-gifts"]
          expect(bookshop_gift).to eq([{ "coupon" => "12345",
                                         "coupon-available" => true }])
        end
      end
      context 'with multiple bookshop gifts' do
        let!(:bookshop_gift_package1) { create(:bookshop_gift_package, package: package) }
        let!(:bookshop_gift_package2) { create(:bookshop_gift_package, package: package) }
        let!(:bookshop_gift1) do
          create(:bookshop_gift, :available, bookshop_gift_package: bookshop_gift_package1)
        end
        let!(:bookshop_gift2) do
          create(:bookshop_gift,
                 :to_be_available,
                 coupon: 'coupon-example',
                 bookshop_gift_package: bookshop_gift_package2)
        end
        it 'returns a list of orders filtered by user_iud with multiple bookshop gift' \
           'information' do
          get :index, params: { user_uid: user.uid }

          assert_jsonapi_response(:success, [order1], OrderSerializer, [:package])
          bookshop_gift = parsed_response["data"].first["attributes"]["bookshop-gifts"]
          expect(bookshop_gift).to eq([{ "coupon" => "12345",
                                         "coupon-available" => true },
                                       { "coupon" => "coupon-example",
                                         "coupon-available" => false }])
        end
      end
    end
    context 'without authentication' do
      it 'should returns http unauthorized' do
        get :index

        assert_type_and_status(:unauthorized)
      end
    end
  end

  describe 'GET #show' do
    context 'as an Admin' do
      it 'returns an user order' do
        authentication_headers_for(admin)
        get :show, params: { id: order1.token }

        assert_type_and_status(:success)
      end
    end

    context 'as an User' do
      context 'with your own order' do
        it 'returns order' do
          authentication_headers_for(user2)
          get :show, params: { id: order2.token }

          expect(parsed_response).not_to include('meta')
          assert_type_and_status(:success)
        end
      end

      context 'with order from other user' do
        it 'returns not found' do
          authentication_headers_for(user)
          get :show, params: { id: order2.token }

          assert_type_and_status(:not_found)
        end
      end
    end
  end

  def base_attributes
    { broker_product_id: 'assinatura_me_salva_engenharia',
      broker: 'play_store',
      email: 'user@google_play.com',
      amount_in_cents: '1000',
      price_paid: '100' }
  end

  def assert_updatable_attributes(attr, entity)
    attr.each do |key, value|
      expect(value).to eq(entity.public_send(key))
    end
  end

  def assert_not_updatable_attributes(attr, entity)
    attr.each do |key, value|
      expect(value).not_to eq(entity.public_send(key))
    end
  end
end

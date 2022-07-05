# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'viewable package' do
  it 'returns the package with 200 status code' do
    get :index,
        params: { education_segment_slug: education_segment_node.slug,
                  platform: 'web' }

    expect(response.headers.keys).not_to include_authorization_keys
    assert_jsonapi_response(:success,
                            [Package.last],
                            PackageSerializer,
                            [:prices])
  end
end

RSpec.describe PackagesController, type: :controller do
  include PermissionHelper

  let!(:node) { create(:node) }
  let!(:feature) { create(:feature) }
  let!(:product) { create(:tangible_product) }
  let!(:product2) { create(:tangible_product) }
  let!(:valid_attributes) do
    FactoryBot.attributes_for(:package_with_price_attributes,
                              tangible_product_id: product.id,
                              tangible_product_discount_percent: 10,
                              node_ids: [node.id], feature_ids: [feature.id])
  end

  let(:error) { { 'identifier' => ['já está em uso'] } }
  let(:meta_update) { Iugu::Plan.new(id: 1, identifier: 1, name: 'other name') }

  let(:education_segment_node) do
    create(:node, name: 'ENEM e Vestibulares')
  end
  let!(:package) do
    create(:package_valid_with_price,
           listed: true)
  end

  describe 'GET index' do
    context 'as admin' do
      before { admin_session }
      context 'with valid filter params' do
        it_behaves_like 'viewable package'
      end
      context 'without filter params' do
        it 'returns all packages' do
          get :index
          assert_jsonapi_response(:success,
                                  Package.all.to_ary,
                                  PackageSerializer,
                                  [:prices])
        end
      end
      context 'with only one filter' do
        it 'returns packages filtered by education segment' do
          get :index,
              params: { education_segment_slug: education_segment_node.slug }
          assert_jsonapi_response(:success,
                                  [package],
                                  PackageSerializer,
                                  [:prices])
        end
        it 'return packages filtered by platform' do
          get :index, params: { platform: 'web' }
          assert_jsonapi_response(:success,
                                  [package],
                                  PackageSerializer,
                                  [:prices])
        end
      end
    end

    context 'as user' do
      context 'with valid filter params' do
        it_behaves_like 'viewable package'
      end
      context 'without filter params' do
        it 'returns unauthorized' do
          get :index
          assert_type_and_status(:unauthorized)
        end
      end
    end
  end

  describe 'GET show' do
    context 'without authentication' do
      it 'returns a serialized Package' do
        get :show, params: { slug: package.slug }

        assert_jsonapi_response(:success, package, PackageSerializer, [:prices])
      end
    end

    context 'with authentication' do
      context 'without bookshop gifts' do
        it 'returns a serialized Package' do
          authentication_headers_for(user)
          get :show, params: { slug: package.slug }

          assert_jsonapi_response(:success, package, PackageSerializer, [:prices])
          bookshop_gift_stats = parsed_response["data"]["attributes"]["bookshop-gift-stats"]
          expect(bookshop_gift_stats).to eq([])
        end
      end
      context 'with one bookshop gift package' do
        let!(:bookshop_gift_package) { create(:bookshop_gift_package, package: package) }
        let!(:bookshop_gift1) do
          create(:bookshop_gift, :used, bookshop_gift_package: bookshop_gift_package)
        end
        let!(:bookshop_gift2) do
          create(:bookshop_gift, :used, bookshop_gift_package: bookshop_gift_package)
        end
        let!(:bookshop_gift3) do
          create(:bookshop_gift, :used, bookshop_gift_package: bookshop_gift_package)
        end
        let!(:bookshop_gift4) do
          create(:bookshop_gift, bookshop_gift_package: bookshop_gift_package)
        end
        let!(:bookshop_gift5) do
          create(:bookshop_gift, bookshop_gift_package: bookshop_gift_package)
        end
        it 'returns a serialized Package' do
          authentication_headers_for(user)
          get :show, params: { slug: package.slug }

          assert_jsonapi_response(:success, package, PackageSerializer, [:prices])
          bookshop_gift_stats = parsed_response["data"]["attributes"]["bookshop-gift-stats"]
          expect(bookshop_gift_stats).to eq([{ "used" => 3, "unused" => 2 }])
        end
      end
      context 'with multiple bookshop gifts packages' do
        let!(:bookshop_gift_package1) { create(:bookshop_gift_package, package: package) }
        let!(:bookshop_gift_package2) { create(:bookshop_gift_package, package: package) }
        let!(:bookshop_gift1) do
          create(:bookshop_gift, :used, bookshop_gift_package: bookshop_gift_package1)
        end
        let!(:bookshop_gift2) do
          create(:bookshop_gift, :used, bookshop_gift_package: bookshop_gift_package1)
        end
        let!(:bookshop_gift3) do
          create(:bookshop_gift, :used, bookshop_gift_package: bookshop_gift_package1)
        end
        let!(:bookshop_gift4) do
          create(:bookshop_gift, bookshop_gift_package: bookshop_gift_package1)
        end
        let!(:bookshop_gift5) do
          create(:bookshop_gift, bookshop_gift_package: bookshop_gift_package1)
        end
        let!(:bookshop_gift6) do
          create(:bookshop_gift, :used, bookshop_gift_package: bookshop_gift_package2)
        end
        let!(:bookshop_gift7) do
          create(:bookshop_gift, :used, bookshop_gift_package: bookshop_gift_package2)
        end
        let!(:bookshop_gift8) do
          create(:bookshop_gift, bookshop_gift_package: bookshop_gift_package2)
        end
        it 'returns a serialized Package' do
          authentication_headers_for(user)
          get :show, params: { slug: package.slug }

          assert_jsonapi_response(:success, package, PackageSerializer, [:prices])
          bookshop_gift_stats = parsed_response["data"]["attributes"]["bookshop-gift-stats"]
          expect(bookshop_gift_stats).to eq([{ "used" => 3, "unused" => 2 },
                                             { "used" => 2, "unused" => 1 }])
        end
      end
    end
  end

  describe 'POST create' do
    context 'as an admin' do
      before { admin_session }
      context 'with valid attributes' do
        context 'without child packages' do
          it 'creates a new package and bookshop_gift_package' do
            expect do
              post :create, params: valid_attributes
            end.to change(Package, :count).by(1).and change(BookshopGiftPackage, :count).by(1)
            assert_jsonapi_response(:created, Package.last, PackageSerializer, [:prices])
            expect(parsed_response['data']['attributes']).to include('node-ids')
            packages = Package.last
            expect(packages.nodes).not_to be_empty
            expect(packages.features).to eq([feature])
            expect(packages.package_type).to eq('Básico')
            expect(packages.complementary).to eq(false)
            expect(packages.tangible_product_id).to eq(product.id)
            expect(package.tangible_product_discount_percent).to eq(10)
          end
        end

        context 'and child packages' do
          let!(:child_package1) { create(:package_valid_with_price) }
          let!(:child_package2) { create(:package_valid_with_price) }
          it 'creates a new package and new complementary packages' do
            expect do
              post :create, params: valid_attributes
                .merge(child_package_ids: [child_package1.id, child_package2.id])
                .merge(complementary: true)
            end.to change(Package, :count).by(1).and change(ComplementaryPackage, :count).by(2)
            assert_jsonapi_response(:created, Package.last, PackageSerializer, [:prices])

            package = Package.last
            package_children = ComplementaryPackage.last(2)
            expect(package.complementary).to eq(true)
            expect(package_children.first.package_id).to eq(package.id)
            expect(package_children.second.package_id).to eq(package.id)
            expect(package_children.first.child_package_id).to eq(child_package1.id)
            expect(package_children.second.child_package_id).to eq(child_package2.id)
          end
        end
      end

      context 'with invalid attributes' do
        let(:attributes) { FactoryBot.attributes_for(:package_invalid) }

        it 'returns unprocessable_entity status' do
          expect do
            post :create, params: attributes
          end.to change(Package, :count).by(0)

          assert_type_and_status(:unprocessable_entity)
        end
      end

      context 'pagarme enabled' do
        before do
          valid_attributes[:subscription] = subscription
        end

        context 'when subscription' do
          let(:subscription) { true }

          it 'creates a plan on pagarme' do
            expect(MeSalva::Billing::Plan)
              .to receive(:create)
              .with(package: instance_of(::Package))

            post :create, params: valid_attributes
          end
        end

        context 'when NOT subscription' do
          let(:subscription) { false }

          it 'creates a plan on pagarme' do
            expect(MeSalva::Billing::Plan)
              .to_not receive(:create)
              .with(package: instance_of(::Package))

            post :create, params: valid_attributes
          end
        end
      end
    end

    context 'as a user' do
      it 'returns http unauthorized' do
        user_session
        post :create, params: valid_attributes

        assert_type_and_status(:unauthorized)
      end
    end

    context 'without authentication' do
      it 'should returns http unauthorized' do
        post :create, params: valid_attributes

        assert_type_and_status(:unauthorized)
        expect(response.headers.keys).not_to include_authorization_keys
      end
    end
  end

  describe 'PUT update' do
    context 'as an admin' do
      before { admin_session }
      context 'with valid params' do
        it 'updates the requested package' do
          package = create(:package_valid_with_price)

          put :update,
              params: { slug: package.slug,
                        name: 'other package name',
                        package_type: 'Completo',
                        tangible_product_discount_percent: 12.5,
                        tangible_product_id: product2.id }
          package.reload

          assert_type_and_status(:ok)
          expect(package.name).to eq('other package name')
          expect(package.package_type).to eq('Completo')
          expect(package.tangible_product_id).to eq(product2.id)
          expect(package.tangible_product_discount_percent).to eq(12.5)
        end

        context 'and child packages' do
          let!(:package_to_update) { create(:package_valid_with_price, complementary: true) }
          let!(:child_package_old1) { create(:package_valid_with_price) }
          let!(:child_package_old2) { create(:package_valid_with_price) }
          let!(:complementary_package1) do
            create(:complementary_package,
                   package_id: package_to_update.id,
                   child_package_id: child_package_old1.id)
          end
          let!(:complementary_package2) do
            create(:complementary_package,
                   package_id: package_to_update.id,
                   child_package_id: child_package_old2.id)
          end
          let!(:child_package_new1) { create(:package_valid_with_price) }
          let!(:child_package_new2) { create(:package_valid_with_price) }
          let!(:child_package_new3) { create(:package_valid_with_price) }
          it 'updates a package and replace its two complementary packages for another two' do
            expect do
              put :update, params: { slug: package_to_update.slug,
                                     child_package_ids: [child_package_new1.id,
                                                         child_package_new2.id],
                                     complementary: true }
            end.to change(Package, :count).by(0).and change(ComplementaryPackage, :count).by(0)

            assert_type_and_status(:ok)
            package_to_update.reload
            package_children = ComplementaryPackage.last(2)
            expect(package_to_update.complementary).to eq(true)
            expect(package_children.first.package_id).to eq(package_to_update.id)
            expect(package_children.second.package_id).to eq(package_to_update.id)
            expect(package_children.first.child_package_id).to eq(child_package_new1.id)
            expect(package_children.second.child_package_id).to eq(child_package_new2.id)
          end

          it 'updates a package and remove one of its complementary packages' do
            expect do
              put :update, params: { slug: package_to_update.slug,
                                     child_package_ids: [child_package_new1.id],
                                     complementary: true }
            end.to change(Package, :count).by(0).and change(ComplementaryPackage, :count).by(-1)

            assert_type_and_status(:ok)
            package_to_update.reload
            package_children = ComplementaryPackage.last
            expect(package_to_update.complementary).to eq(true)
            expect(package_children.package_id).to eq(package_to_update.id)
            expect(package_children.child_package_id).to eq(child_package_new1.id)
          end

          it 'updates a package and add one to its complementary packages' do
            expect do
              put :update, params: { slug: package_to_update.slug,
                                     child_package_ids: [child_package_new1.id,
                                                         child_package_new2.id,
                                                         child_package_new3.id],
                                     complementary: true }
            end.to change(Package, :count).by(0).and change(ComplementaryPackage, :count).by(1)

            assert_type_and_status(:ok)
            package_to_update.reload
            package_children = ComplementaryPackage.last(3)
            expect(package_to_update.complementary).to eq(true)
            expect(package_children.first.package_id).to eq(package_to_update.id)
            expect(package_children.second.package_id).to eq(package_to_update.id)
            expect(package_children.third.package_id).to eq(package_to_update.id)
            expect(package_children.first.child_package_id).to eq(child_package_new1.id)
            expect(package_children.second.child_package_id).to eq(child_package_new2.id)
            expect(package_children.third.child_package_id).to eq(child_package_new3.id)
          end
        end
      end

      context 'with valid params' do
        context 'with a package' do
          let!(:package) { create(:package_valid_with_price) }
          context 'with a new node' do
            let!(:new_node) { create(:node) }
            context 'keeping the current node' do
              it 'adds a node to the package' do
                package_nodes = package.node_ids
                package_nodes << new_node.id
                put :update, params: { slug: package.slug, node_ids: package_nodes }
                package.reload

                assert_type_and_status(:ok)
                expect(package.nodes.count).to eq(2)
                expect(package_nodes).to include(package.nodes.first.id)
                expect(package_nodes).to include(package.nodes.second.id)
              end
            end
            context 'removing the current node' do
              it 'does not allow to remove the node' do
                package_nodes = [new_node.id]
                node_before_update = package.nodes.first.id
                put :update, params: { slug: package.slug, node_ids: package_nodes }
                package.reload

                assert_type_and_status(:method_not_allowed)
                expect(package.nodes.count).to eq(1)
                expect(package.nodes.first.id).to eq(node_before_update)
              end
            end
          end
        end
      end

      context 'pagarme enabled' do
        before do
          package.update!(
            pagarme_plan_id: pagarme_plan_id,
            subscription: subscription
          )
        end

        context 'when subscription' do
          let(:subscription) { true }

          context 'package has pagarme.plan_id' do
            let(:pagarme_plan_id) { 1 }

            context 'with subscription' do
              it 'updates a plan on pagarme' do
                expect(MeSalva::Billing::Plan)
                  .to receive(:update)
                  .with(package: package)

                put :update, params: { slug: package.slug, name: 'other name' }
              end
            end
          end

          context 'package has no pagarme.plan_id' do
            it_behaves_like 'a package that does not update' do
              let(:plan_id) { '' }
            end
          end
        end

        context 'when NOT subscription' do
          let(:subscription) { false }

          context 'package has pagarme.plan_id' do
            it_behaves_like 'a package that does not update' do
              let(:plan_id) { '1' }
            end
          end
        end
      end

      context 'with invalid params' do
        it 'should returns http unprocessable entity' do
          package = create(:package_valid_with_price)
          put :update, params: { slug: package.slug,
                                 name: 'other package name',
                                 duration: nil }

          assert_type_and_status(:unprocessable_entity)
          expect(assigns(:package)).to eq(package)
        end

        it 'should returns http not found' do
          create(:package_valid_with_price)
          put :update, params: { slug: 'slug-nao-existe', name: 'other name' }

          assert_type_and_status(:not_found)
        end
      end
    end
    context 'without authentication' do
      it 'should returns http unauthorized' do
        package = create(:package_valid_with_price)
        put :update, params: { slug: package.slug, name: 'other package name' }

        assert_type_and_status(:unauthorized)
        expect(response.headers.keys).not_to include_authorization_keys
      end
    end
  end

  describe 'PUT update_bookshop_gift' do
    context 'as an admin' do
      before { admin_session }
      context 'with valid params' do
        let!(:old_package) { create(:package_valid_with_price) }
        let!(:new_package) { create(:package_valid_with_price) }
        let!(:bookshop_gift_package) { create(:bookshop_gift_package, package_id: old_package.id) }
        let!(:bookshop_gift) do
          create(:bookshop_gift, bookshop_gift_package_id: bookshop_gift_package.id)
        end
        it 'updates the bookshop gift from requested package' do
          put :update_bookshop_gift,
              params: { slug: old_package.slug, package_id: new_package.id }

          bookshop_gift_package.reload
          assert_type_and_status(:ok)
          expect(bookshop_gift_package.package_id).to eq(new_package.id)
        end
      end

      context 'with invalid params' do
        context 'for a invalid slug' do
          it 'does not update the bookshop gift from requested package' do
            put :update_bookshop_gift, params: { slug: 'invalid_slug' }

            assert_type_and_status(:not_found)
          end
        end
        context 'for a invalid new package' do
          let!(:old_package) { create(:package_valid_with_price) }
          let!(:new_package) { create(:package_valid_with_price) }
          let!(:bookshop_gift_package) do
            create(:bookshop_gift_package, package_id: old_package.id)
          end
          let!(:bookshop_gift) do
            create(:bookshop_gift, bookshop_gift_package_id: bookshop_gift_package.id)
          end
          it 'does not update the bookshop gift from requested package' do
            put :update_bookshop_gift,
                params: { slug: old_package.slug, package_id: 4 }

            assert_type_and_status(:unprocessable_entity)
          end
        end
      end
    end
  end

  describe 'GET features' do
    context 'as admin' do
      before { user_session }
      before { grant_test_permission('features') }
      context 'with all features' do
        let!(:study_plan) { create(:feature, :study_plan) }
        let!(:default_essay) { create(:feature, :default_essay) }
        let!(:custom_essay) { create(:feature, :custom_essay) }
        let!(:text_plan) { create(:feature, :text_plan) }
        let!(:mentoring) { create(:feature, :mentoring) }
        let!(:private_class) { create(:feature, :private_class) }
        let!(:books) { create(:feature, :books) }
        let!(:unlimited_essay) { create(:feature, :unlimited_essay) }
        let!(:mentoring_credits) { create(:feature, :mentoring_credits) }
        let!(:features_package_feature) { create(:package_feature, feature: default_essay) }
        let!(:features_package_feature2) do
          create(:package_feature, feature: custom_essay, package: features_package_feature.package)
        end

        context 'with invalid params' do
          context 'for a invalid slug' do
            it 'returns all possible features without package' do
              get :features, params: { slug: 'invalid-slug' }
              expect(response).to have_http_status(:not_found)
            end
          end
        end
        context 'with slug' do
          it 'returns all possible features with packages' do
            clear_unused_features
            get :features, params: { slug: features_package_feature.package.slug }
            assert_type_and_status(:ok)
            response_data = parsed_response["results"]

            expect(response_data.count).to eq(9)
            expect(response_data[0]["slug"]).to eq(study_plan.slug)
            expect(response_data[1]["slug"]).to eq(default_essay.slug)
            expect(response_data[2]["slug"]).to eq(custom_essay.slug)
            expect(response_data[3]["slug"]).to eq(text_plan.slug)
            expect(response_data[4]["slug"]).to eq(mentoring.slug)
            expect(response_data[5]["slug"]).to eq(private_class.slug)
            expect(response_data[6]["slug"]).to eq(books.slug)
            expect(response_data[7]["slug"]).to eq(unlimited_essay.slug)
            expect(response_data[8]["slug"]).to eq(mentoring_credits.slug)

            expect(response_data[0]["has"]).to eq(false)
            expect(response_data[1]["has"]).to eq(true)
            expect(response_data[2]["has"]).to eq(true)
            expect(response_data[3]["has"]).to eq(false)
            expect(response_data[4]["has"]).to eq(false)
            expect(response_data[5]["has"]).to eq(false)
            expect(response_data[6]["has"]).to eq(false)
            expect(response_data[7]["has"]).to eq(false)
            expect(response_data[8]["has"]).to eq(false)
          end
        end
      end
    end
  end

  def clear_unused_features
    Feature.where("slug LIKE 'feature%'").delete_all
  end
end

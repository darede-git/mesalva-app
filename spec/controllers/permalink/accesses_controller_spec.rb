# frozen_string_literal: true

require 'rails_helper'
require 'me_salva/permalinks/builder'

RSpec.describe Permalink::AccessesController, type: :controller do
  include PermalinkBuildingHelper

  let!(:user) { create(:user) }
  let!(:node1) { create(:node) }
  let!(:node2) { create(:node_area, parent_id: node1.id) }
  let!(:node3) { create(:node_subject, parent_id: node2.id) }
  let!(:node_module) { create(:node_module, nodes: [node3]) }
  let!(:item) { create(:item, node_modules: [node_module]) }
  let!(:medium) { create(:medium, items: [item]) }

  let!(:node2_package) do
    create(:package_valid_with_price, node_ids: [node2.id])
  end

  let!(:create_access) do
    create(:access, :one_month, user_id: user.id, package: node2_package)
  end

  describe.skip 'GET #show' do
    before { build_permalinks(node1, :subtree) }
    context 'as an user' do
      context 'with a node1 with node2 child and only node2 access' do
        context 'V2' do
          let(:valid_response) do
            { 'data' => {
              'id' => node1.slug,
              'type' => 'access',
              'attributes' => {
                'permalink-slug' => node1.slug,
                'status-code' => 402,
                'children' => [
                  { 'permalink-slug' => node2.slug,
                    'status-code' => 200 }
                ]
              }
            } }
          end
          it 'returns the permalink accesses in jsonapi format' do
            authentication_headers_for(user)
            add_custom_headers('Api-Version' => '2')

            get :show, params: { slug: first_permalink_slug_for(node1) }

            assert_type_and_status(:success)
            expect(parsed_response).to eq(valid_response)
          end
        end
        context 'V1' do
          let(:valid_response) do
            { 'permalink-access' => {
              'children' => [{ 'permalink-slug' => node2.slug,
                               'status-code' => 200 }],
              'permalink-slug' => node1.slug,
              'status-code' => 402
            } }
          end
          it 'returns the permalink accesses with status codes' do
            authentication_headers_for(user)

            get :show, params: { slug: first_permalink_slug_for(node1) }

            assert_type_and_status(:success)
            expect(parsed_response).to eq(valid_response)
          end
        end
      end

      context 'with a node module permalink' do
        it_behaves_like 'a valid response' do
          let(:permalink_slug) { node_module }
        end
      end

      context 'with a medium permalink' do
        it_behaves_like 'a valid response' do
          let(:permalink_slug) { medium }
        end
      end
    end
  end

  def first_permalink_slug_for(entity)
    permalink_entities_for(entity).first.slug
  end

  def permalink_entities_for(entity)
    entity.permalinks.with_ordered_entities
  end
end

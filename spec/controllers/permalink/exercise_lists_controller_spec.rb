# frozen_string_literal: true

require 'rails_helper'
require 'me_salva/permalinks/builder'

RSpec.describe Permalink::ExerciseListsController, type: :controller do
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

  describe 'GET #show' do
    before { build_permalinks(node1, :subtree) }
    context 'as an user' do
      before { user_session }
      context 'with valid slug' do
        it 'returns a valid object' do
          get :show, params: { slug: Permalink.last.slug }

          assert_type_and_status(:success)
          expect(parsed_response.first).to include("statement", "answers", "difficulty", "correct")
        end
      end
    end
  end
end

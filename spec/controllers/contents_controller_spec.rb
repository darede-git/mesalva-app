# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ContentsController, type: :controller do
  let(:node) { create(:node) }
  let(:node_module) { create(:node_module) }
  let(:item) { create(:item) }
  let(:medium) { create(:medium) }

  context '#show' do
    before { user_platform_session }
    context 'has node' do
      it 'returns serialized content' do
        get :show, params: { token: node.token }
        expect(parsed_response['slug']).to eq(node.slug)
      end
    end

    context 'has node_module' do
      before { create(:item, node_module_ids: [node_module.id]) }
      it 'returns serialized content' do
        get :show, params: { token: node_module.token }
        expect(parsed_response['slug']).to eq(node_module.slug)
      end
    end

    context 'has item' do
      it 'returns serialized content' do
        get :show, params: { token: item.token }
        expect(parsed_response['slug']).to eq(item.slug)
      end
    end

    context 'has medium' do
      it 'returns serialized content' do
        get :show, params: { token: medium.token }
        expect(parsed_response['slug']).to eq(medium.slug)
      end
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LpBlocksController, type: :controller do
  before { admin_session }
  context 'admin' do
    let!(:lp_block) do
      create(:lp_block, :hero)
    end
    let!(:lp_blocks) do
      create_pair(:lp_block, type_of: "block")
    end
    context 'show based on id' do
      it 'return lp section' do
        get :show, params: { id: lp_block.id }
        expect(parsed_response['data'][0]['attributes']['name']).to eq('HeroEnem')
      end
    end
    context 'show based on type' do
      it 'return two blocks' do
        get :show, params: { type_of: lp_blocks.first.type_of }
        expect(parsed_response['data'].size).to eq(2)
      end
    end
    context 'update' do
      it 'return lp block' do
        get :update, params: { id: lp_block.id, name: 'HeroEssay', type_of: 'block' }

        response_attributes = parsed_response['data'][0]['attributes']
        expect(response_attributes['name']).to eq('HeroEssay')
        expect(response_attributes['schema']).to eq('{"some":"schema"}')
        expect(lp_block.reload.name).to eq('HeroEssay')
        expect(lp_block.reload.type_of).to eq('block')
      end
    end

    context 'create' do
      it 'return lp block' do
        get :create, params: { name: 'SimpleSection', schema: { "some": "other-value" } }
        expect(parsed_response['data']['attributes']['name']).to eq('SimpleSection')
        expect(parsed_response['data']['attributes']['type_of']).to eq('section')
      end
    end
    context 'index' do
      let!(:lp_block2) do
        create(:lp_block, :faq)
      end
      it 'return lp blocks' do
        get :index
        expect(parsed_response['data'][0]['attributes']['name']).to eq(lp_blocks.first.name)
        expect(parsed_response['data'][2]['attributes']['name']).to eq(lp_block.name)
        expect(parsed_response['data'][3]['attributes']['name']).to eq(lp_block2.name)
      end
    end
    context 'destroy' do
      it 'soft destroy one block' do
        get :destroy, params: { id: lp_block.id }

        expect(parsed_response['success']).to eq(true)
        expect(LpBlock.find(lp_block.id).active).to eq(false)
      end
    end
  end
end

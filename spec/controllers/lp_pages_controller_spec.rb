# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LpPagesController, type: :controller do
  context 'admin' do
    before { admin_session }
    let!(:lp_page) { create(:lp_page, :enem) }
    let!(:lp_page2) { create(:lp_page, :enem, created_at: '2021-02-01T00:00:01') }
    context 'show' do
      it 'returns ordered by most recent lp pages' do
        get :show, params: { slug: lp_page.slug }

        response_attributes = parsed_response['data']
        expect(response_attributes[0]['id']).to eq(lp_page2.id.to_s)
        expect(response_attributes[1]['id']).to eq(lp_page.id.to_s)
      end
    end
    context 'update' do
      it 'returns lp page' do
        get :update, params: { slug: lp_page.slug, name: 'Enem e vestibulares' }

        response_attributes = parsed_response['data'][0]['attributes']
        expect(response_attributes['name']).to eq('Enem e vestibulares')
        expect(response_attributes['data']).to eq('{"some":"value"}')
        expect(lp_page.reload.name).to eq('Enem e vestibulares')
      end
    end

    context 'create' do
      it 'returns lp pages' do
        get :create, params: { name: 'Redação', slug: 'enem/redacao', \
                               data: { "some": "other-value" }, schema: { "some": "other-value" } }
        response_attributes = parsed_response['data']['attributes']
        expect(response_attributes['name']).to eq('Redação')
      end
    end
    context 'index' do
      let!(:lp_page3) do
        create(:lp_page, :redacao)
      end
      it 'returns lp pages' do
        get :index
        first_lp = parsed_response['data'][0]['attributes']
        second_lp = parsed_response['data'][1]['attributes']
        third_lp = parsed_response['data'][2]['attributes']
        expect(first_lp['name']).to eq(lp_page.name)
        expect(second_lp['name']).to eq(lp_page2.name)
        expect(third_lp['name']).to eq(lp_page3.name)
      end
    end
    context 'destroy' do
      it 'soft destroy one block' do
        get :destroy, params: { slug: lp_page.slug }

        expect(parsed_response['success']).to eq(true)
        expect(LpPage.find(lp_page.id).active).to eq(false)
      end
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SchoolsController, type: :controller do
  context 'valid params' do
    let!(:school) do
      create(:school)
    end
    context '#show' do
      it 'returns a school' do
        get :show, params: { id: school.id }
        assert_apiv2_response(:ok, school, V2::SchoolSerializer)
      end
    end
  end
end

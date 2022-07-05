# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User::PrepTestOverviewsController, type: :controller do
  let(:default_serializer) { V2::PrepTestOverviewSerializer }

  context 'bucas resultado do teste do aluno' do
    before { user_session }
    let(:userPrepTest) do
      create(:prep_test_overview, user_uid: user.uid)
    end
    it 'busca user_prep_test' do
      get :index, params: { permalink_slug: "exemple-permalink", user_uid: userPrepTest.user_uid }

      assert_apiv2_response(:ok, [userPrepTest], default_serializer)
    end
  end
end

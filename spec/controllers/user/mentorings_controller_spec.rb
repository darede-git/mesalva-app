# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User::MentoringsController, type: :controller do
  let(:default_serializer) { V2::MentoringSerializer }
  describe "mentoring" do
    context '#index' do
      let!(:mentoring1) { create(:mentoring, user: user, starts_at: Time.now - 1.day) }
      let!(:mentoring2) { create(:mentoring, user: user, starts_at: Time.now + 1.day) }
      let!(:mentoring3) { create(:mentoring) }

      context 'as user' do
        before { user_session }

        context 'without filters' do
          it 'returns a mentoring' do
            get :index
            assert_apiv2_response(:ok,
                                  [mentoring1, mentoring2],
                                  default_serializer, nil,
                                  { page: 1, per_page: 5, total_pages: 1 })
          end
        end
        context 'with next_only filter' do
          it 'returns a mentoring' do
            get :index, params: { next_only: 'true' }
            assert_apiv2_response(:ok,
                                  [mentoring2],
                                  default_serializer, nil,
                                  { page: 1, per_page: 5, total_pages: 1 })
          end
        end
      end
    end
  end
end

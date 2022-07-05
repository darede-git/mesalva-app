# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:essay) do
    create(:essay_submission, user: user)
  end
  let(:admin) do
    create(:admin)
  end
  let(:user) do
    create(:user)
  end

  describe 'POST #create' do
    let(:comment_attributes) do
      FactoryBot.attributes_for(:comment)
                .merge(essay_submission_id: essay.token)
    end
    context 'with valid attributes' do
      it_behaves_like 'a valid comment' do
        let(:user_role) { admin }
      end

      it_behaves_like 'a valid comment' do
        let(:user_role) { teacher }
      end

      context 'as an user' do
        before { authentication_headers_for(user) }
        it_behaves_like 'a unauthorized comment' do
          let(:user_role) { user }
        end
      end

      context 'as a guest' do
        it_behaves_like 'a unauthorized comment' do
          let(:user_role) { guest }
        end
      end
    end

    context 'with invalid attributes' do
      before { authentication_headers_for(admin) }
      it 'render http status unprocessable entity' do
        post :create, params: { essay_submission_id: essay.token }

        assert_type_and_status(:unprocessable_entity)
      end
    end
  end

  describe 'PUT #update' do
    let(:comment) do
      create(:comment, commenter: admin, commentable: essay)
    end
    context 'with valid attributes' do
      before { authentication_headers_for(admin) }
      it 'returns http status 200' do
        put :update, params: { id: comment.token, text: 'Updated comment' }

        expect(comment.reload.text).to eq('Updated comment')
        assert_jsonapi_response(:ok, comment, CommentSerializer)
      end
    end

    context 'with invalid attributes' do
      before { authentication_headers_for(admin) }
      context 'comment does not exist' do
        it 'returns http status not found' do
          put :update, params: { id: '404 token', text: 'do not matter' }

          assert_type_and_status(:not_found)
        end
      end

      context 'parameters are invalid' do
        it 'returns http status unprocessable_entity' do
          put :update, params: { id: comment.token, text: '' }

          assert_type_and_status(:unprocessable_entity)
        end
      end
    end
  end
end

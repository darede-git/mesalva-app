# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InternalNotesController, type: :controller do
  let!(:internal_note) do
    create(:comment, commenter: admin, commentable: user)
  end

  let(:user) do
    create(:user)
  end

  let(:admin) do
    create(:admin)
  end

  describe 'POST #create' do
    let(:valid_attributes) do
      FactoryBot.attributes_for(:comment).merge(user_uid: user.uid)
    end
    context 'as admin' do
      before { authentication_headers_for(admin) }
      context 'with valid attributes' do
        it 'create a comment and returns http status created' do
          post :create, params: valid_attributes

          assert_jsonapi_response(:created, user.internal_notes.first,
                                  CommentSerializer)
        end
      end

      context 'with invalid comment attributes' do
        it 'returns http status unprocessable_entity' do
          post :create, params: { user_uid: user.uid }

          assert_type_and_status(:unprocessable_entity)
        end
      end

      context 'with no user uid' do
        it 'returns http status not found' do
          post :create, params: { text: 'Texto' }

          assert_type_and_status(:not_found)
        end
      end
    end

    context 'as user' do
      before { authentication_headers_for(user) }
      it 'returns http status unauthorized' do
        post :create, params: valid_attributes

        assert_type_and_status(:unauthorized)
      end
    end
  end

  describe 'PUT #update' do
    context 'as admin' do
      before { authentication_headers_for(admin) }
      context 'with valid_attributes' do
        it 'updates comment and returns http status ok' do
          put :update, params: {
            token: internal_note.token,
            text: 'Atualiza aê'
          }

          assert_jsonapi_response(:ok, user.internal_notes.first,
                                  CommentSerializer)
        end
      end

      context 'with invalid attributes' do
        it 'returns http status unprocessable_entity' do
          put :update, params: { token: internal_note.token, text: '' }

          assert_type_and_status(:unprocessable_entity)
        end
      end

      context 'with a non existent internal note token' do
        it 'returns http status not found' do
          put :update, params: { token: 'Não existe', text: 'Texto' }

          assert_type_and_status(:not_found)
        end
      end
    end

    context 'as user' do
      before { authentication_headers_for(user) }
      it 'returns http status unauthorized' do
        put :update, params: { token: internal_note.token, text: 'Atualiza aê' }

        assert_type_and_status(:unauthorized)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'as admin' do
      before { authentication_headers_for(admin) }
      context 'internal note exists' do
        it 'deletes internal note and returns http status no content' do
          delete :destroy, params: { token: internal_note.token }

          expect(response).to have_http_status(:no_content)
          expect(response.content_type).to eq(nil)
        end
      end

      context 'internal note does not exist' do
        it 'returns http status unauthorized' do
          delete :destroy, params: { token: 'Não existe' }

          assert_type_and_status(:not_found)
        end
      end
    end

    context 'as user' do
      before { authentication_headers_for(user) }
      context 'internal note exists' do
        it 'returns http status' do
          delete :destroy, params: { token: internal_note.token }

          assert_type_and_status(:unauthorized)
        end
      end
    end
  end

  describe 'GET #index' do
    context 'as admin' do
      let!(:internal_note2) do
        create(:comment, commentable: user, commenter: admin)
      end
      before { authentication_headers_for(admin) }
      context 'user exists' do
        it 'returns a list of internal notes' do
          get :index, params: { user_uid: user.uid }

          sorted_notes = [internal_note, internal_note2]
                         .sort_by(&:created_at).reverse
          expect(parsed_response['data'].map { |note| note['id'] })
            .to eq(sorted_notes.map(&:token))
        end
      end
    end
  end
end

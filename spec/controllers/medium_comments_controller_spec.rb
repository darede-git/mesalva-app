# frozen_string_literal: true

require 'rails_helper'
require 'me_salva/permalinks/builder'

RSpec.describe CommentsController, type: :controller do
  let!(:node) { create(:node) }
  let!(:node_module) { create(:node_module, node_ids: [node.id]) }
  let!(:item) do
    create(:item, free: false, node_module_ids: [node_module.id])
  end
  let!(:medium) do
    create(:medium, item_ids: [item.id], medium_type: 'video')
  end

  let!(:comment) do
    create(:comment, commenter: user, commentable: medium)
  end

  let(:package) do
    create(:package_valid_with_price, node_ids: [node.id])
  end
  let(:create_access) do
    create(:access, user_id: user.id, package_id: package.id,
                    expires_at: Time.now + 1.month)
  end

  let!(:invalid_attributes) { { text: '' } }

  before do
    MeSalva::Permalinks::Builder.new(
      entity_id: node.id,
      entity_class: 'Node'
    ).build_subtree_permalinks
  end
  describe 'GET #index' do
    context 'as an user' do
      before do
        authentication_headers_for(user)
      end
      it_behaves_like 'viewable_comment'
    end
    context 'as a guest' do
      it_behaves_like 'viewable_comment'
    end
  end

  describe 'POST create' do
    let!(:comment_attributes) do
      { text: 'pi',
        permalink_slug: medium.permalinks.first.slug }
    end

    context 'as an admin' do
      before { admin_session }
      it 'with valid attributes should creates a medium comment' do
        create_comment(comment_attributes, 1)

        assert_jsonapi_response(:created, Comment.last)
      end

      it 'with invalid params should returns http unprocessable entity' do
        create_comment(invalid_attributes, 0)

        assert_type_and_status(:unprocessable_entity)
      end
    end

    context 'as an teacher' do
      before { teacher_session }
      it 'with valid attributes should creates a medium comment' do
        create_comment(comment_attributes, 1)

        assert_jsonapi_response(:created, Comment.last)
      end

      it 'with invalid params should returns http unprocessable entity' do
        create_comment(invalid_attributes, 0)

        assert_type_and_status(:unprocessable_entity)
      end
    end

    context 'as an user' do
      before { user_session }
      context 'with valid access' do
        before { create_access }
        it 'with valid attributes should creates a medium comment' do
          create_comment(comment_attributes, 1)

          assert_jsonapi_response(:created, Comment.last)
        end

        it 'with invalid params should returns http unprocessable entity' do
          create_comment(invalid_attributes, 0)

          assert_type_and_status(:unprocessable_entity)
        end
      end

      it 'with invalid access returns http payment required' do
        create_comment(comment_attributes, 0)

        assert_type_and_status(:payment_required)
      end
    end

    it 'without authentication should returns http unauthorized' do
      create_comment(invalid_attributes, 0)

      assert_type_and_status(:unauthorized)
    end
  end

  context 'PUT update' do
    context 'as an admin' do
      context 'with valid attributes' do
        it_behaves_like 'a updated medium comment request' do
          let(:user_role_session) { admin_session }
          let(:user_role) { admin }
        end
      end
    end

    context 'as a teacher' do
      context 'with valid attributes' do
        it_behaves_like 'a updated medium comment request' do
          let(:user_role_session) { teacher_session }
          let(:user_role) { teacher }
        end
      end
    end

    context 'as an user' do
      context 'with valid access' do
        before { create_access }

        context 'update his medium comment' do
          it_behaves_like 'a updated medium comment request' do
            let(:user_role_session) { user_session }
            let(:user_role) { user }
          end
        end

        context 'update another user medium comment' do
          let!(:another_comment) do
            create(:comment,
                   commenter: create(:user),
                   commentable: medium)
          end
          it 'with valid attributes returns unauthorized' do
            put :update, params: { id: another_comment.token,
                                   text: 'new attributes' }

            expect(response).to have_http_status(:unauthorized)
          end

          it 'deactive the medium comment' do
            put :update, params: { id: another_comment.token, active: false }

            expect(response).to have_http_status(:unauthorized)
          end
        end
      end
    end

    it 'with invalid access should return http unauthorized' do
      put :update, params: { id: comment.token, active: false }

      expect(response).to have_http_status(:unauthorized)
    end
  end

  def create_comment(attributes, count)
    expect do
      post :create, params: attributes
    end.to change(Comment, :count).by(count)
  end
end

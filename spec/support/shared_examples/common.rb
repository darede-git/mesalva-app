# frozen_string_literal: true

RSpec.shared_examples 'a valid subject' do
  it 'returns subject.valid? as true' do
    expect(subject.valid?).to be_truthy
  end
end

RSpec.shared_examples 'a valid comment' do
  context 'as an admin/teacher' do
    before { authentication_headers_for(user_role) }
    it 'creates an essay_submission comment' do
      post :create, params: comment_attributes

      assert_jsonapi_response(:created, essay.comments.last,
                              CommentSerializer)
    end
  end
end

RSpec.shared_examples 'a unauthorized comment' do
  context 'as an user or guest' do
    it 'returns http status :unauthorized' do
      post :create, params: comment_attributes

      assert_type_and_status(:unauthorized)
    end
  end
end

RSpec.shared_examples 'viewable_comment' do
  it 'returns http success' do
    get :index, params: { permalink_slug: medium.permalinks.first.slug }

    expect(parsed_response['data']).to eq(
      JSON.parse(to_jsonapi([comment].to_ary, CommentSerializer))['data']
    )
    expect(parsed_response).to include('links')
  end
end

RSpec.shared_examples 'updated medium comment request' do
  before { user_role_session }
  context 'with valid attributes' do
    it 'updates the requested medium comment' do
      put :update, params: { token: comment.token,
                             text: 'new attributes',
                             permalink_slug: medium.permalinks.last.slug }
      assert_jsonapi_response(:success, comment.reload, CommentSerializer)
    end

    it 'deactive the requested medium comment' do
      put :update, params: { token: comment.token,
                             active: false,
                             permalink_slug: medium.permalinks.last.slug }

      expect(comment.reload.active).to be_falsey
      assert_jsonapi_response(:success, comment.reload, CommentSerializer)
    end

    context 'with invalid attributes' do
      it 'with invalid attributes should returns unprocessable entity' do
        put :update, params: { token: comment.token,
                               text: '',
                               permalink_slug: medium.permalinks.last.slug }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end

RSpec.shared_examples 'returns http ok' do
  it 'http status should be ok' do |example|
    VCR.use_cassette(test_name(example) + order.broker.to_s) do
      put :update, params: { order_id: order.token }

      assert_type_and_status(:ok)
      expect(parsed_response['data']['attributes']['status'])
        .to eq('refunded')
    end
  end
end

RSpec.shared_examples 'creates a question, faq or testimonial' do
  before { admin_session }
  it 'creates a subject' do
    post :create, params: valid_attributes

    assert_jsonapi_response(:created, model,
                            serializer_class)
    assert_created_by(model, admin)
  end
end

RSpec.shared_examples 'a valid response' do
  let(:slug) { first_permalink_slug_for(permalink_slug) }
  let(:valid_response) do
    { 'data' => {
      'id' => slug,
      'type' => 'access',
      'attributes' => {
        'permalink-slug' => slug,
        'status-code' => 200,
        'children' => []
      }
    } }
  end
  it 'returns the permalink accesses with node module status codes' do
    authentication_headers_for(user)
    add_custom_headers('Api-Version' => '2')
    create_access

    get :show, params: { slug: first_permalink_slug_for(permalink_slug) }

    assert_type_and_status(:success)
    expect(parsed_response).to eq(valid_response)
  end
end

RSpec.shared_examples 'a logged profile' do
  it 'can see logged profile' do
    get :show, params: { uid: user_role.uid }

    assert_headers_for(user_role_logged)
    assert_type_and_status(:ok)
    expect(parsed_response['data']['attributes']['uid']).to eq(
      user_role.uid.to_s
    )
  end
end

RSpec.shared_examples 'a valid subscription' do
  before do
    package.update(subscription: true)
    package.update(pagarme_plan_id: 172_945)
    payment_method[:amount_in_cents] = 1000
    valid_attributes[:payment_methods] = [payment_method]
  end

  it 'creates a valid subscription by card' do |example|
    VCR.use_cassette(test_name(example) + status) do
      expect do
        post :create, params: valid_attributes
      end.to change(::Order, :count)
        .by(1).and change(::OrderPayment, :count)
        .by(1).and change(::Subscription, :count)
        .by(1).and change(::Access, :count)
        .by(count_change).and change(ActionMailer::Base.deliveries, :count)
        .by(payment_method_emails_sent_quantity(payment_method[:method]))

      expect(Order.last.status).to eq(order_status_count)
      expect(
        OrderPayment.last.state_machine.current_state
      ).to eq(payment_status)
      attributes = parsed_response['data']['attributes']
      expect(attributes['status']).to eq(status)
      expect(attributes['subscription-id']).not_to be_nil
      expect(attributes['payment-methods'].first['state'])
        .to eq(payment_status)
    end
  end

  private

  def payment_method_emails_sent_quantity(payment_method)
    return 0 unless payment_method.eql? 'bank_slip'

    1
  end
end

RSpec.shared_examples 'a updated medium comment request' do
  before { user_role_session }
  it 'updates the requested medium comment' do
    put :update, params: { id: comment.token, text: 'new attributes' }

    assert_jsonapi_response(:success, comment.reload, CommentSerializer)
  end

  it 'deactive the requested medium comment' do
    put :update, params: { id: comment.token, active: false }

    expect(comment.reload.active).to be_falsey
    assert_jsonapi_response(:success, comment.reload, CommentSerializer)
  end

  it 'with invalid attributes should returns unprocessable entity' do
    put :update, params: { id: comment.token, text: '' }

    expect(response).to have_http_status(:unprocessable_entity)
  end
end

RSpec.shared_examples 'a package that does not update' do
  context 'without subscription' do
    let(:pagarme_plan_id) { plan_id }

    it 'does NOT update a plan on pagarme' do
      expect(MeSalva::Billing::Plan)
        .to_not receive(:update)
        .with(package: package)

      put :update, params: { slug: package.slug, name: 'other name' }
    end
  end
end

RSpec.shared_examples 'a transit order' do
  it 'should transit order' do
    post :create, params: valid_pagarme_postback
    expect(response).to have_http_status(:no_content)
    expect(response.content_type).to eq(nil)
    assert_payment_status(card1, payment_status)
    assert_order_status(order, 2)
  end
end

RSpec.shared_examples 'an unauthorized status' do
  it 'returns unauthorized status' do
    expect do
      post :create, params: valid_attributes
    end.to change(model, :count).by(0)

    expect(response).to have_http_status(:unauthorized)
  end
end

RSpec.shared_examples 'unauthorized http status for user' do
  before { user_session }
  context 'with valid params' do
    it 'returns http unauthorized' do
      put :update, params: { id: id, name: name }

      expect(response).to have_http_status(:unauthorized)
    end
  end
end

RSpec.shared_examples 'a destroyed request' do
  context 'as admin' do
    it 'destroys the requested item' do
      admin_session
      expect do
        delete :destroy, params: { id: id }
      end.to change(model, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end

  context 'as user' do
    it 'returns http unauthorized' do
      user_session
      delete :destroy, params: { id: id }
      expect(response).to have_http_status(:unauthorized)
    end
  end
end

# frozen_string_literal: true

RSpec.shared_examples 'a accessible index route for' do |roles|
  roles.each do |role|
    context "as #{role}" do
      before { build_session(role) }

      it "returns all entities" do
        get :index

        assert_jsonapi_response(:ok, [entity], default_serializer)
      end
    end
  end
end
%i[index create].each do |route|
  RSpec.shared_examples "a unauthorized #{route} route for" do |roles|
    roles.each do |role|
      context "as #{role}" do
        before { build_session(role) }
        it "returns http unauthorized" do
          get route
          assert_type_and_status(:unauthorized)
        end
      end
    end
  end
end
%i[show destroy].each do |route|
  RSpec.shared_examples "a unauthorized #{route} route for" do |roles|
    roles.each do |role|
      context "as #{role}" do
        before { build_session(role) }
        it 'returns http unauthorized' do
          get route, params: { id: entity.to_param }

          assert_type_and_status(:unauthorized)
        end
      end
    end
  end
end
RSpec.shared_examples 'a accessible index public route' do
  %w[guest user admin].each do |role|
    before { build_session(role) }
    context "as #{role}" do
      it "returns all entities" do
        get :index
        assert_jsonapi_response(:ok, [entity], default_serializer)
        expect(response.headers.keys).not_to include_authorization_keys
      end
    end
  end
end

RSpec.shared_examples 'a accessible show route for' do |roles|
  roles.each do |role|
    context "as #{role}" do
      before { build_session(role) }
      it "returns entities" do
        get :show, params: { id: entity.to_param }
        assert_jsonapi_response(:ok, entity, default_serializer)
      end
    end
  end
end

RSpec.shared_examples 'a not found response for action' do |actions|
  actions.each do |action|
    before { build_session(allowed_role) }
    it 'returns http unauthorized' do
      get action, params: { id: 0 }
      assert_type_and_status(:not_found)
    end
  end
end

RSpec.shared_examples 'a accessible show public route' do
  %w[guest user admin].each do |role|
    context "as #{role}" do
      before { build_session(role) }
      it "returns entitie" do
        get :show, params: { id: entity.to_param }
        assert_jsonapi_response(:ok, entity, default_serializer)
      end
    end
  end
end

RSpec.shared_examples 'a accessible create route for' do |roles|
  roles.each do |role|
    context "as #{role}" do
      before { build_session(role) }
      context "with valid params" do
        it "creates a new entity and returns it" do
          expect do
            post :create, params: valid_attributes
          end.to change(default_model, :count).by(1)

          assert_jsonapi_response(:created,
                                  default_model.last,
                                  default_serializer)
        end
      end
      context "with invalid params" do
        it "returns unprocessable_entity" do
          post :create, params: invalid_attributes

          assert_type_and_status(:unprocessable_entity)
        end
      end
    end
  end
end

RSpec.shared_examples 'a accessible update route for' do |roles|
  roles.each do |role|
    context "as #{role}" do
      before { build_session(role) }
      context "with valid params" do
        it "updates the requested entity" do
          put :update, params: new_attributes.merge(id: entity.to_param)

          assert_jsonapi_response(:ok, entity.reload, default_serializer)
        end
      end
      context "with invalid params" do
        it "returns unprocessable_entity" do
          put :update, params: invalid_attributes.merge(id: entity.to_param)

          assert_type_and_status(:unprocessable_entity)
        end
      end
    end
  end
end
RSpec.shared_examples 'a unauthorized update route for' do |roles|
  roles.each do |role|
    context "as #{role}" do
      before { build_session(role) }
      it 'returns http unauthorized' do
        put :update, params: new_attributes.merge(id: entity.to_param)

        assert_type_and_status(:unauthorized)
      end
    end
  end
end

RSpec.shared_examples 'a accessible destroy route for' do |roles|
  roles.each do |role|
    before { build_session(role) }
    context "as #{role}" do
      it "destroys the requested entity" do
        expect do
          delete :destroy, params: { id: entity.to_param }
        end.to change(default_model, :count).by(-1)
        expect(response).to have_http_status(:no_content)
      end
    end
  end
end

def build_session(role)
  public_send("#{role}_session") unless role == 'guest'
end

def assert_headers(role)
  return assert_headers_for(public_send(role)) unless role == 'guest'

  expect(response.headers.keys).not_to include_authorization_keys
end

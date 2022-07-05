# frozen_string_literal: true

RSpec.shared_examples 'a controller with a permitted parameter' do |parameters|
  parameters.each do |param|
    it "permits the given param on create and update" do
      attribute = param[:attribute]
      create_val = param[:create_val]
      update_val = param[:update_val]

      post :create, params: valid_attributes.merge(attribute => create_val)

      response_data = parsed_response['data']
      model = response_data['type'].singularize.underscore.camelcase
      model = "Quiz::#{model.sub('Quiz', '')}" if model.starts_with? 'Quiz'
      entity = model.constantize.find(response_data['id'])
      expect(entity.send(attribute)).to eq create_val

      post :update, params: { id: entity, attribute => update_val }
      entity.reload

      expect(entity.send(attribute)).to eq update_val
    end
  end
end

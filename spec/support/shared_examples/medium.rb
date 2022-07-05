# frozen_string_literal: true

RSpec.shared_examples 'a payment or login required for' do |medium_types|
  medium_types.each do |medium_type|
    Rails.cache.clear
    context "medium type #{medium_type}" do
      let!(:medium) { create("medium_#{medium_type}".to_sym) }

      it 'returns unauthorized' do
        get :show, params: {
          slug: medium.slug,
          permalink_slug: permalink.slug,
          format: :json
        }

        assert_type_and_status(status.to_sym)
      end
    end
  end
end

RSpec.shared_examples 'a viewable medium for' do |medium_types|
  medium_types.each do |medium_type|
    Rails.cache.clear
    let(:medium) { create("medium_#{medium_type}".to_sym) }

    context "medium type is #{medium_type}" do
      it 'returns the medium with 200 status code' do
        get :show, params: {
          slug: medium.slug,
          permalink_slug: permalink.slug,
          format: :json
        }

        assert_jsonapi_response(
          :ok, medium, Permalink::Relation::ChildMediumSerializer
        )
      end
    end
  end
end

RSpec.shared_examples 'a viewable exercise medium' do
  it 'returns the medium with 200 status code' do
    %w[comprehension_exercise fixation_exercise].each do |medium_type|
      Rails.cache.clear
      medium.medium_type = medium_type
      medium.audit_status = 'reviewed'
      medium.answers = [
        Answer.new(text: 'Alternativa 1', correct: true, active: true),
        Answer.new(text: 'Alternativa 2', correct: false, active: true),
        Answer.new(text: 'Alternativa 3', correct: false, active: true),
        Answer.new(text: 'Alternativa 4', correct: false, active: true),
        Answer.new(text: 'Alternativa 5', correct: false, active: true)
      ]

      medium.save!
      get :show, params: {
        slug: medium.slug,
        permalink_slug: permalink.slug,
        format: :json
      }

      assert_jsonapi_response(
        :ok, medium, Permalink::Relation::ChildMediumSerializer,
        ['answers']
      )
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Teacher::SessionsController, type: :controller do
  before { @request.env['devise.mapping'] = Devise.mappings[:teacher] }

  include_context 'session'

  let(:resource) do
    create(:teacher, email: resource_email, password: password)
  end

  let(:resource_response) do
    { 'data' =>
      { 'id' => 'person@mesalva.com',
        'type' => 'teachers',
        'attributes' =>
          { 'uid' => 'person@mesalva.com',
            'name' => "Teacher Me Salva!",
            'image' => { 'url' => resource.image.url },
            'email' => 'person@mesalva.com',
            'description' => "This is an teacher!",
            'birth-date' => nil,
            'active' => true } } }
  end

  describe 'POST create' do
    context 'email session' do
      context 'with valid attributes' do
        context 'normal email' do
          let(:email) { resource_email }
          it_behaves_like 'a valid session'
        end
        context 'upcase email' do
          let(:email) { resource_email.upcase }
          it_behaves_like 'a valid session'
        end
      end

      context 'with invalid attributes' do
        it_behaves_like 'an unauthorized session for inactive resource'
        it_behaves_like 'an unauthorized session for invalid credentials'
        it_behaves_like 'an unauthorized session for an inexistent resource'
      end
    end
  end

  describe 'DELETE #destroy' do
    it_behaves_like 'a session destroyer'
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::SessionsController, type: :controller do
  before { @request.env['devise.mapping'] = Devise.mappings[:admin] }

  include_context 'session'

  let(:resource) do
    create(:admin, email: resource_email, password: password, image: nil)
  end

  let(:resource_response) do
    { 'data' =>
      { 'id' => 'person@mesalva.com',
        'type' => 'admins',
        'attributes' =>
          { 'uid' => 'person@mesalva.com',
            'name' => resource.name,
            'image' => { 'url' => nil },
            'email' => 'person@mesalva.com',
            'description' => "This is an admin!",
            'birth-date' => nil,
            'role' => 'dev',
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
          let(:resource_response) do
            { 'data' =>
                { 'id' => 'person@mesalva.com',
                  'type' => 'admins',
                  'attributes' =>
                    { 'uid' => 'person@mesalva.com',
                      'name' => resource.name,
                      'image' => { 'url' => nil },
                      'email' => 'person@mesalva.com',
                      'description' => "This is an admin!",
                      'birth-date' => nil,
                      'role' => 'dev',
                      'active' => true } } }
          end

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

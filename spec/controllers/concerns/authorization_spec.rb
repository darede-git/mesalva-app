# frozen_string_literal: true

require 'rails_helper'

describe Authorization do
  subject(:test_instance) { TestClass.new }
  let(:user) do
    create(:user,
           email: 'user@teste.com',
           tokens: { 'WEB' =>
            { 'token' => '$2a$10$i9sUowLNQY7/XSCylLzGWuG0jb3zYPq9Z'\
              'S1hlJnR1RY4WeAx1VC6e',
              'expiry' => (Time.now + 2.weeks).to_i,
              'updated_at' => Time.now.to_s } })
  end

  let(:header_keys) { %w[access-token token-type client expiry uid] }
  let(:user_session) do
    { 'access-token' => 'kaTuL76JKSqWb9PmwnQYQA',
      'client' => 'WEB', 'uid' => user.uid }
  end

  before do
    allow(test_instance).to receive(:current_user).and_return(user)
    allow_resource('user', true)
    allow_resource('teacher', false)
    allow_resource('admin', false)
  end

  describe '#update_auth_headers' do
    context 'passing auth headers,' do
      it 'returns a new auth headers' do
        allow(test_instance).to receive(:request)
          .and_return(OpenStruct.new(headers: user_session))
        allow(test_instance).to receive(:response)
          .and_return(OpenStruct.new(headers: {}))
        response_headers = test_instance.update_auth_headers

        expect(response_headers.keys).to eq(header_keys)
      end
    end
  end

  describe '#set_user_by_token' do
    context 'passing auth headers,' do
      it 'returns the user' do
        allow(test_instance).to receive(:request)
          .and_return(OpenStruct.new(headers: user_session))
        allow(test_instance).to receive(:response)
          .and_return(OpenStruct.new(headers: {}))
        response_user = test_instance.set_user_by_token(:user)

        expect(response_user).to eq(user)
      end
    end
  end

  def allow_resource(resource, condition)
    allow(test_instance).to receive("#{resource}_signed_in?".to_sym)
      .and_return(condition)
  end
end

class TestClass < ActionController::Base
  include Authorization
end

# frozen_string_literal: true

require 'rails_helper'

describe SocialLogin do
  subject(:test_instance) { TestClass.new }

  describe '#auth_hash' do
    context 'when omniauth.auth is present on the request' do
      it 'returns the omniauth.auth hash' do
        hash = {
          provider: 'facebook',
          uid: '1234567',
          info: {
            email: 'joe@bloggs.com',
            name: 'Joe Bloggs',
            first_name: 'Joe',
            last_name: 'Bloggs'
          }
        }
        allow(test_instance).to receive_message_chain(:request, :env)
          .and_return('omniauth.auth' => hash)
        expect(test_instance.auth_hash).to eq(hash)
      end
    end

    context 'when omniauth.auth is not present on the request' do
      before do
        allow(test_instance).to receive_message_chain(:request, :env)
          .and_return('omniauth.auth' => nil)
      end

      context 'facebook login' do
        before do
          allow(subject).to receive(:params)
            .and_return(parameters('facebook'))
        end

        context 'with a valid token' do
          it 'returns a facebook user hash' do
            allow(HTTParty).to receive_message_chain(:get, :parsed_response)
              .and_return('uid' => '123', 'info' => { 'name' => 'Vader' })

            expect(test_instance.auth_hash).to include('info')
            expect(test_instance.auth_hash).to include('uid')
          end
        end

        context 'with an invalid token' do
          it 'return an error hash' do
            allow(HTTParty).to receive_message_chain(:get, :parsed_response)
              .and_return('error' => { 'message' => 'Erro' })

            expect(test_instance.auth_hash).to be_nil
          end
        end
      end

      context 'google login' do
        before do
          allow(subject).to receive(:params)
            .and_return(parameters('google'))
        end

        context 'with a valid token' do
          it 'returns a google user hash' do
            allow(HTTParty).to receive_message_chain(:get, :parsed_response)
              .and_return('uid' => '123', 'info' => { 'name' => 'Vader' })

            expect(test_instance.auth_hash).to include('info')
            expect(test_instance.auth_hash).to include('uid')
          end
        end

        context 'with an invalid token' do
          it 'return an error hash' do
            allow(subject).to receive(:params)
              .and_return(parameters('google'))
            allow(HTTParty).to receive_message_chain(:get, :parsed_response)
              .and_return('error' => { 'message' => 'Erro' })

            expect(test_instance.auth_hash).to be_nil
          end
        end
      end

      context 'apple login' do
        before do
          allow(subject).to receive(:params)
            .and_return(parameters('apple'))
        end

        context 'with a valid token' do
          it 'returns a google user hash' do
            allow(HTTParty).to receive_message_chain(:post, :parsed_response)
              .and_return(
                'id_token' =>
                "eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL2FwcGxlaWQuYXBwbGUuY\
                29tIiwiYXVkIjoiY29tLm1lc2FsdmEuZXhlcmNpY2lvc0VuZW1WZXN0aWJ1bGFy\
                ZXMiLCJleHAiOjE1ODkzMTUwMjEsImlhdCI6MTU4OTMxNDQyMSwic3ViIjoiMDA\
                xNjk2LjVmZWQ1NDk2Nzk0ZTRkZjc4NTY3Zjk1YzFiODZlODk0LjExMzkiLCJub2\
                5jZSI6IjA3YTUwYjg4OGZiZGFiN2I2NzNjMWM2OGE5OTVkYjdmMGY0NWQ3NTFmO\
                DdmYzNhNmUzY2RjZWMyMzRkNjVmNzYiLCJhdF9oYXNoIjoiMDFaUV9XWmJSTGZW\
                SHVUelZsd2t3ZyIsImVtYWlsIjoiZGFydGhAdmFkZXIubWUiLCJlbWFpbF92ZXJ\
                pZmllZCI6InRydWUiLCJhdXRoX3RpbWUiOjE1ODkzMTQyNzUsIm5vbmNlX3N1cH\
                BvcnRlZCI6dHJ1ZX0.Hr1CqywMao8JghmyOSx1_CziXafGqnu8L4nhBek7Sxc"
              )

            expect(test_instance.auth_hash).to include('info')
            expect(test_instance.auth_hash).to include('uid')
          end
        end
      end

      context 'with an invalid provider' do
        it 'returns an error hash' do
          allow(subject).to receive(:params)
            .and_return(parameters('invalid'))

          expect(test_instance.auth_hash)
            .to eq('error' =>
            { 'message' => t('devise_token_auth.sessions.invalid_provider') })
        end
      end
    end
  end

  def parameters(provider)
    { 'provider' => provider,
      'token' => 'tOkEn' }
  end
end

class TestClass < ActionController::Base
  include SocialLogin
end

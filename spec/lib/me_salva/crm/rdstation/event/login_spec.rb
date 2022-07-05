# frozen_string_literal: true

require 'spec_helper'

RSpec.shared_examples 'an rdstation event signup' do |clients|
  clients.each do |client|
    context "with client is #{client}" do
      context 'through sender class' do
        let(:subject) do
          MeSalva::Crm::Rdstation::Event::Sender.new(event: signup_name.to_sym,
                                                     params: { user: user,
                                                               client: client })
        end

        before do
          expect_login_in_rd(signup_events[client], signup_attributes)
        end

        it 'create sign_up event' do
          subject.send_event
        end
      end
      context 'direct from login class' do
        let(:subject) do
          MeSalva::Crm::Rdstation::Event::Login.new({ user: user,
                                                      client: client })
        end

        before do
          expect_login_in_rd(signup_events[client], signup_attributes)
        end

        it 'create sign_up event' do
          subject.sign_up
        end
      end
    end
  end
end

RSpec.shared_examples 'an rdstation event signin' do |clients|
  clients.each do |client|
    context "with client is #{client}" do
      context 'through sender class' do
        let(:subject) do
          MeSalva::Crm::Rdstation::Event::Sender.new(event: signin_name.to_sym,
                                                     params: { user: user,
                                                               client: client })
        end

        before do
          expect_login_in_rd(signin_events[client], signin_attributes)
        end

        it 'create sign_in event' do
          subject.send_event
        end
      end
      context 'direct from login class' do
        let(:subject) do
          MeSalva::Crm::Rdstation::Event::Login.new({ user: user,
                                                      client: client })
        end

        before do
          expect_login_in_rd(signin_events[client], signin_attributes)
        end

        it 'create sign_in event' do
          subject.sign_in
        end
      end
    end
  end
end

describe MeSalva::Crm::Rdstation::Event::Login do
  let(:signup_name) { "sign_up" }
  let(:signup_events) do
    {
      'WEB' => 'cadastro-me-salva-web',
      'IOS' => 'cadastro-me-salva-ios',
      'ANDROID' => 'cadastro-me-salva-android',
      'ANDROID-QUESTOES' => 'cadastro-me-salva-android-questoes',
      'ANY-OTHER-CLIENT' => 'cadastro-me-salva-any-other-client'
    }
  end
  let(:signin_name) { "sign_in" }
  let(:signin_events) do
    {
      'WEB' => 'sign_in|web',
      'IOS' => 'sign_in|ios',
      'ANDROID' => 'sign_in|android',
      'ANDROID-QUESTOES' => 'sign_in|android-questoes',
      'ANY-OTHER-CLIENT' => 'sign_in|any-other-client'
    }
  end

  describe '#sign_up' do
    let(:signup_attributes) do
      { cf_conta_ms_criada_em: user.created_at.to_s,
        cf_mesalva_uid: user.uid }
    end
    it_behaves_like 'an rdstation event signup', %w[WEB
                                                    IOS
                                                    ANDROID
                                                    ANDROID-QUESTOES
                                                    ANY-OTHER-CLIENT]
  end
  describe '#sign_in' do
    let(:signin_attributes) do
      {}
    end
    it_behaves_like 'an rdstation event signin', %w[WEB
                                                    IOS
                                                    ANDROID
                                                    ANDROID-QUESTOES
                                                    ANY-OTHER-CLIENT]
  end

  def expect_login_in_rd(event_name, attributes)
    client = double
    expect(MeSalva::Crm::Rdstation::Event::Client).to receive(:new)
      .with({ user: user,
              event_name: event_name,
              payload: attributes })
      .and_return(client)
    expect(client).to receive(:create)
  end
end

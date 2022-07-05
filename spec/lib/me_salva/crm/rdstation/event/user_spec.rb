# frozen_string_literal: true

require 'spec_helper'

describe MeSalva::Crm::Rdstation::Event::User do
  let(:default_attributes) { { user_setting.key => user_setting.value } }

  describe '#settings' do
    context 'for a user setting changed' do
      let!(:user_setting) { create(:user_setting) }
      event_name = 'user_settings'
      context 'through sender class' do
        let(:subject) do
          MeSalva::Crm::Rdstation::Event::Sender.new(event: event_name.to_sym,
                                                     params: { user: user,
                                                               key: user_setting.key,
                                                               value: user_setting.value })
        end
        before do
          expect_client_receive("user-setting-changed|#{user_setting.key}", default_attributes)
        end

        it 'creates rdstation settings event' do
          subject.send_event
        end
      end
      context 'direct from user class' do
        let(:subject) do
          MeSalva::Crm::Rdstation::Event::User.new({ user: user,
                                                     key: user_setting.key,
                                                     value: user_setting.value })
        end
        before do
          expect_client_receive("user-setting-changed|#{user_setting.key}", default_attributes)
        end

        it 'creates rdstation settings event' do
          subject.settings
        end
      end
    end
  end

  def expect_client_receive(event_name, attributes)
    client = double
    expect(MeSalva::Crm::Rdstation::Event::Client).to receive(:new)
      .with({ user: user,
              event_name: event_name,
              payload: attributes }).and_return(client)
    expect(client).to receive(:create)
  end
end

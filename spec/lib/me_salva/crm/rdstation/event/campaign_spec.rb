# frozen_string_literal: true

require 'spec_helper'

describe MeSalva::Crm::Rdstation::Event::Campaign do
  let(:example_campaign) { 'example-campaign' }
  let(:default_attributes) { { cf_campaign_view_name: example_campaign } }
  describe '#campaign' do
    context 'for campaign_sign_up event' do
      event_name = "campaign_sign_up"
      context 'through sender class' do
        let(:subject) do
          MeSalva::Crm::Rdstation::Event::Sender.new(event: event_name.to_sym,
                                                     params: { user: user,
                                                               campaign_name: example_campaign })
        end
        before do
          expect_campaign_sign_up_in_rd(event_name, default_attributes)
        end

        it 'creates rdstation campaign_sign_up event' do
          subject.send_event
        end
      end
      context 'direct from campaign class' do
        let(:subject) do
          MeSalva::Crm::Rdstation::Event::Campaign.new({ user: user,
                                                         campaign_name: example_campaign })
        end
        before do
          expect_campaign_sign_up_in_rd(event_name, default_attributes)
        end
        it 'creates rdstation campaign_sign_up event' do
          subject.sign_up
        end
      end
    end
  end

  def expect_campaign_sign_up_in_rd(event_name, attributes)
    client = double
    expect(MeSalva::Crm::Rdstation::Event::Client).to receive(:new)
      .with({ user: user,
              event_name: "#{event_name}|#{example_campaign}",
              payload: attributes })
      .and_return(client)
    expect(client).to receive(:create)
  end
end

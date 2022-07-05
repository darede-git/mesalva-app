# frozen_string_literal: true

require 'spec_helper'

describe MeSalva::Crm::Rdstation::Event::Sender do
  describe '#sender' do
    context 'send_event method' do
      context 'with an invalid event' do
        event_name = "invalid_event"
        let(:subject) do
          MeSalva::Crm::Rdstation::Event::Sender.new(event: event_name.to_sym,
                                                     params: { user: user })
        end
        it 'does not send any event' do
          expect(subject.send_event).to be(nil)
        end
      end
      let(:package) do
        create(:package_valid_with_price)
      end
      let(:default_attributes) do
        { cf_package_name: package.name,
          cf_package_slug: package.slug,
          cf_package_duration: package.duration.to_s,
          cf_package_sku: package.sku }
      end
      describe 'with a valid event' do
        event_name = "checkout_view"
        context 'through sender class' do
          let(:subject) do
            MeSalva::Crm::Rdstation::Event::Sender.new(event: event_name.to_sym,
                                                       params: { user: user,
                                                                 package: package })
          end
          before do
            client = double
            expect(MeSalva::Crm::Rdstation::Event::Client).to receive(:new)
              .with({ user: user,
                      event_name: "#{event_name}|#{package.sku}",
                      payload: default_attributes })
              .and_return(client)
            expect(client).to receive(:create)
          end

          it 'send an event' do
            subject.send_event
          end
        end
      end
    end
  end
end

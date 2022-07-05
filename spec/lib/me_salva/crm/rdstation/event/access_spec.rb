# frozen_string_literal: true

require 'spec_helper'

describe MeSalva::Crm::Rdstation::Event::Access do
  let(:default_attributes) do
    {
      cf_package_name: order.package.name,
      cf_package_slug: order.package.slug,
      cf_package_duration: order.package.duration.to_s,
      cf_package_sku: order.package.sku
    }
  end

  describe '#renewal_today' do
    context 'for renewal_today' do
      event_name = 'access_renewal_today'
      context 'through sender class' do
        let(:subject) do
          MeSalva::Crm::Rdstation::Event::Sender.new(event: event_name.to_sym,
                                                     params: { user: order.user,
                                                               package: order.package })
        end
        let(:order) { create(:order_with_pagarme_subscription, user: user) }
        before do
          expect_client_receive('wpp-renovacao-0-dias|enem-semestral', default_attributes)
        end

        it 'creates rdstation renewal today event' do
          subject.send_event
        end
      end
      context 'direct from payment class' do
        let(:subject) do
          MeSalva::Crm::Rdstation::Event::Access.new({ user: order.user,
                                                       package: order.package })
        end
        let(:order) { create(:order_with_pagarme_subscription, user: user) }

        before do
          expect_client_receive('wpp-renovacao-0-dias|enem-semestral', default_attributes)
        end

        it 'creates rdstation renewal_today event' do
          subject.renewal_today
        end
      end
    end
  end

  describe '#renewal_30_days' do
    context 'for renewal_30_days' do
      event_name = 'access_renewal_30_days'
      context 'through sender class' do
        let(:subject) do
          MeSalva::Crm::Rdstation::Event::Sender.new(event: event_name.to_sym,
                                                     params: { user: order.user,
                                                               package: order.package })
        end
        let(:order) { create(:order_with_pagarme_subscription, user: user) }
        before do
          expect_client_receive('wpp-renovacao-30-dias|enem-semestral', default_attributes)
        end

        it 'creates rdstation renewal_30_days event' do
          subject.send_event
        end
      end
      context 'direct from payment class' do
        let(:subject) do
          MeSalva::Crm::Rdstation::Event::Access.new({ user: order.user,
                                                       package: order.package })
        end
        let(:order) { create(:order_with_pagarme_subscription, user: user) }

        before do
          expect_client_receive('wpp-renovacao-30-dias|enem-semestral', default_attributes)
        end

        it 'creates rdstation renewal_30_days event' do
          subject.renewal_30_days
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

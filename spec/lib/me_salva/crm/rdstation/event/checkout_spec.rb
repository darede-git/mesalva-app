# frozen_string_literal: true

require 'spec_helper'

describe MeSalva::Crm::Rdstation::Event::Checkout do
  let(:package) do
    create(:package_valid_with_price)
  end
  let(:default_attributes) do
    { cf_package_name: package.name,
      cf_package_slug: package.slug,
      cf_package_duration: package.duration.to_s,
      cf_package_sku: package.sku }
  end
  describe '#checkout' do
    context 'for checkout_view event' do
      event_name = "checkout_view"
      context 'through sender class' do
        let(:subject) do
          MeSalva::Crm::Rdstation::Event::Sender.new(event: event_name.to_sym,
                                                     params: { user: user,
                                                               package: package })
        end
        before do
          expect_checkout_view_in_rd(event_name, default_attributes)
        end

        it 'creates rdstation checkout_view event' do
          subject.send_event
        end
      end
      context 'direct from checkout class' do
        let(:subject) do
          MeSalva::Crm::Rdstation::Event::Checkout.new({ user: user,
                                                         package: package })
        end
        before do
          expect_checkout_view_in_rd(event_name, default_attributes)
        end

        it 'creates rdstation checkout_view event' do
          subject.view
        end
      end
    end

    context 'for checkout_client event' do
      event_name = "checkout_client"
      context 'through sender class' do
        let(:subject) do
          MeSalva::Crm::Rdstation::Event::Sender.new(event: event_name.to_sym,
                                                     params: { user: user,
                                                               package: package })
        end
        before do
          expect_checkout_view_in_rd(event_name, default_attributes)
        end

        it 'creates rdstation checkout_client event' do
          subject.send_event
        end
      end
      context 'direct from checkout class' do
        let(:subject) do
          MeSalva::Crm::Rdstation::Event::Checkout.new({ user: user,
                                                         package: package })
        end
        before do
          expect_checkout_view_in_rd(event_name, default_attributes)
        end

        it 'creates rdstation checkout_client event' do
          subject.client
        end
      end
    end

    context 'for checkout_ex_client event' do
      event_name = "checkout_ex_client"
      context 'through sender class' do
        let(:subject) do
          MeSalva::Crm::Rdstation::Event::Sender.new(event: event_name.to_sym,
                                                     params: { user: user,
                                                               package: package })
        end
        before do
          expect_checkout_view_in_rd(event_name, default_attributes)
        end

        it 'creates rdstation checkout_ex_client event' do
          subject.send_event
        end
      end
      context 'direct from checkout class' do
        let(:subject) do
          MeSalva::Crm::Rdstation::Event::Checkout.new({ user: user,
                                                         package: package })
        end
        before do
          expect_checkout_view_in_rd(event_name, default_attributes)
        end

        it 'creates rdstation checkout_ex_client event' do
          subject.ex_client
        end
      end
    end

    context 'for checkout_repurchase_client event' do
      event_name = "checkout_repurchase_client"
      context 'through sender class' do
        let(:subject) do
          MeSalva::Crm::Rdstation::Event::Sender.new(event: event_name.to_sym,
                                                     params: { user: user,
                                                               package: package })
        end
        before do
          expect_checkout_view_in_rd(event_name, default_attributes)
        end

        it 'creates rdstation checkout_repurchase_client event' do
          subject.send_event
        end
      end
      context 'direct from checkout class' do
        let(:subject) do
          MeSalva::Crm::Rdstation::Event::Checkout.new({ user: user,
                                                         package: package })
        end
        before do
          expect_checkout_view_in_rd(event_name, default_attributes)
        end

        it 'creates rdstation checkout_repurchase_client event' do
          subject.repurchase_client
        end
      end
    end

    context 'for checkout_upsell_client event' do
      event_name = "checkout_upsell_client"
      context 'through sender class' do
        let(:subject) do
          MeSalva::Crm::Rdstation::Event::Sender.new(event: event_name.to_sym,
                                                     params: { user: user,
                                                               package: package })
        end
        before do
          expect_checkout_view_in_rd(event_name, default_attributes)
        end

        it 'creates rdstation checkout_upsell_client event' do
          subject.send_event
        end
      end
      context 'direct from checkout class' do
        let(:subject) do
          MeSalva::Crm::Rdstation::Event::Checkout.new({ user: user,
                                                         package: package })
        end
        before do
          expect_checkout_view_in_rd(event_name, default_attributes)
        end

        it 'creates rdstation checkout_upsell_client event' do
          subject.upsell_client
        end
      end
    end
  end

  def expect_checkout_view_in_rd(event_name, attributes)
    client = double
    expect(MeSalva::Crm::Rdstation::Event::Client).to receive(:new)
      .with({ user: user,
              event_name: "#{event_name}|#{package.sku}",
              payload: attributes })
      .and_return(client)
    expect(client).to receive(:create)
  end
end

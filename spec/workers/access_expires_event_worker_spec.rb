# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AccessExpiresEventWorker do
  context 'with orders' do
    let!(:order1) { create(:order) }
    let!(:order2) { create(:order) }
    let!(:order3) { create(:order) }
    let!(:order4) { create(:order) }
    context 'and accesses' do
      let!(:access1) do
        create(:access_with_duration_and_node,
               expires_at: Time.now,
               user: order1.user,
               order: order1,
               package: order1.package)
      end

      let!(:access2) do
        create(:access_with_duration_and_node,
               expires_at: Time.now,
               user: order2.user,
               order: order2,
               package: order2.package)
      end

      let!(:access3) do
        create(:access_with_duration_and_node,
               expires_at: Time.now + 30.day,
               user: order3.user,
               order: order3,
               package: order3.package)
      end

      let!(:access4) do
        create(:access_with_duration_and_node,
               expires_at: Time.now + 40.day,
               user: order4.user,
               order: order4,
               package: order4.package)
      end

      context 'call lib' do
        event_name_today = "wpp-renovacao-0-dias"
        event_name = "wpp-renovacao-30-dias"

        let(:default_attributes1) { default_attributes(order1) }
        let(:default_attributes2) { default_attributes(order2) }
        let(:default_attributes3) { default_attributes(order3) }

        before do
          expect_access_in_rd(order1.user, event_name_today, default_attributes1, order1.package)
          expect_access_in_rd(order2.user, event_name_today, default_attributes2, order2.package)
          expect_access_in_rd(order3.user, event_name, default_attributes3, order3.package)
        end
        it 'creates a rdstation access expiring events for today and 30 days' do
          subject.perform
        end
      end
    end
  end

  def expect_access_in_rd(user, event_name, attributes, package)
    client = double
    expect(MeSalva::Crm::Rdstation::Event::Client).to receive(:new)
      .with({ user: user,
              event_name: "#{event_name}|#{package.sku}",
              payload: attributes })
      .and_return(client)
    expect(client).to receive(:create)
  end

  def default_attributes(order)
    { cf_package_name: order.package.name,
      cf_package_slug: order.package.slug,
      cf_package_duration: order.package.duration.to_s,
      cf_package_sku: order.package.sku }
  end
end

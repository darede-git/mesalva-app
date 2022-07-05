# frozen_string_literal: true

require 'me_salva/crm/events'
require 'spec_helper'

describe MeSalva::Crm::AccessExpires do
  describe 'for event_expire_access method' do
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

        context 'for renewal_today event' do
          event_name = "wpp-renovacao-0-dias"
          let(:default_attributes1) do
            { cf_package_name: order1.package.name,
              cf_package_slug: order1.package.slug,
              cf_package_duration: order1.package.duration.to_s,
              cf_package_sku: order1.package.sku }
          end
          let(:default_attributes2) do
            { cf_package_name: order2.package.name,
              cf_package_slug: order2.package.slug,
              cf_package_duration: order2.package.duration.to_s,
              cf_package_sku: order2.package.sku }
          end
          context 'through access_expires class' do
            let(:subject) { MeSalva::Crm::AccessExpires.new }
            before do
              expect_access_in_rd(order1.user, event_name, default_attributes1, order1.package)
              expect_access_in_rd(order2.user, event_name, default_attributes2, order2.package)
            end
            it 'send events for accesses expiring today' do
              subject.event_expire_access(0)
            end
          end
        end

        context 'for renewal_30_days_ event' do
          event_name = "wpp-renovacao-30-dias"
          let(:default_attributes3) do
            { cf_package_name: order3.package.name,
              cf_package_slug: order3.package.slug,
              cf_package_duration: order3.package.duration.to_s,
              cf_package_sku: order3.package.sku }
          end

          context 'through access_expires class' do
            let(:subject) { MeSalva::Crm::AccessExpires.new }
            before do
              expect_access_in_rd(order3.user, event_name, default_attributes3, order3.package)
            end
            it 'send events for accesses expiring today' do
              subject.event_expire_access(30)
            end
          end
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
end

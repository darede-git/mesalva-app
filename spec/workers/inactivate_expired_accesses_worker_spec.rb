# frozen_string_literal: true

RSpec.describe InactivateExpiredAccessesWorker do
  include UserAccessSpecHelper

  describe '#perform' do
    context 'for unsubscriber user' do
      access_expiring_today = 3
      access_not_expiring_today = 5
      context "for #{access_expiring_today} accesses expiring today " \
              "and #{access_not_expiring_today} not expiring today" do
        let!(:access_expiring_today_1) { create(:access_expiring_today) }
        let!(:access_expiring_today_2) { create(:access_expiring_today) }
        let!(:access_expiring_today_3) { create(:access_expiring_today) }
        before do
          access_not_expiring_today.times { create(:access_expiring_tomorow) }
          access_expiring_today.times do |i|
            expect_rd_station_event(Access.find_by_package_id(Package.all[i].id).user,
                                    'checkout_ex_client',
                                    Package.all[i].sku,
                                    { cf_package_name: Package.all[i].name,
                                      cf_package_slug: Package.all[i].slug,
                                      cf_package_duration: Package.all[i].duration.to_s,
                                      cf_package_sku: Package.all[i].sku })
          end
          Access.update_all(starts_at: Date.yesterday)
        end
        it "inactivate the #{access_expiring_today} expired accesses " \
          "and send #{access_expiring_today} rdstation ex-client events" do
          subject.perform
          expect(Access.inactive.count).to be(access_expiring_today)
          expect(Access.active.count).to be(access_not_expiring_today)
          user_state_transition_asserts(User.find(access_expiring_today_1.user.id), :unsubscriber)
          user_state_transition_asserts(User.find(access_expiring_today_2.user.id), :unsubscriber)
          user_state_transition_asserts(User.find(access_expiring_today_3.user.id), :unsubscriber)
        end
      end
    end
    context 'for ex_subscriber user' do
      access_expiring_today = 3
      access_not_expiring_today = 5
      context "for #{access_expiring_today} accesses expiring today " \
              "and #{access_not_expiring_today} not expiring today" do
        before do
          Order.delete_all
          Access.delete_all
          User.delete_all
        end
        let!(:access_expiring_today_1) { create(:access_expiring_today) }
        let!(:access_expiring_today_2) { create(:access_expiring_today) }
        let!(:access_expiring_today_3) { create(:access_expiring_today) }
        before do
          access_not_expiring_today.times { create(:access_expiring_tomorow) }
          access_expiring_today.times do |i|
            expect_rd_station_event(Access.find_by_package_id(Package.all[i].id).user,
                                    'checkout_ex_client',
                                    Package.all[i].sku,
                                    { cf_package_name: Package.all[i].name,
                                      cf_package_slug: Package.all[i].slug,
                                      cf_package_duration: Package.all[i].duration.to_s,
                                      cf_package_sku: Package.all[i].sku })
          end
          Access.update_all(starts_at: Date.yesterday)
        end
        it "inactivate the #{access_expiring_today} expired accesses " \
          "and send #{access_expiring_today} rdstation ex-client events" do
          first_user_id = User.first.id
          first_user_id.upto(access_expiring_today + first_user_id) do |id|
            create(:subscription, user: User.find(id))
            User.find(id).orders.last.update(subscription_id: Subscription.last.id)
          end
          subject.perform
          expect(Access.inactive.count).to be(access_expiring_today)
          expect(Access.active.count).to be(access_not_expiring_today)
          user_state_transition_asserts(User.find(access_expiring_today_1.user.id), :ex_subscriber)
          user_state_transition_asserts(User.find(access_expiring_today_2.user.id), :ex_subscriber)
          user_state_transition_asserts(User.find(access_expiring_today_3.user.id), :ex_subscriber)
        end
      end
    end
  end

  def expect_rd_station_event(user, event_name, client_type, attributes)
    client = double
    expect(MeSalva::Crm::Rdstation::Event::Client).to receive(:new)
      .with({ user: user,
              event_name: "#{event_name}|#{client_type}",
              payload: attributes })
      .and_return(client)
    expect(client).to receive(:create)
  end
end

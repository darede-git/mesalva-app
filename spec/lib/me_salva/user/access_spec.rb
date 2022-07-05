# frozen_string_literal: true

require 'rails_helper'
require 'me_salva/user/access'

RSpec.describe MeSalva::User::Access do
  include PermalinkCreationHelper
  include PermalinkAssertionHelper
  include UserAccessSpecHelper
  include UserAccessSpecHelper

  let!(:nodes) { parsed_entities(permalink_entities_node) }
  let!(:permalink) { create(:permalink) }
  let!(:user) { create(:user) }

  let(:access_with_expires_at) do
    FactoryBot.attributes_for(:access_with_expires_at, user: user)
  end
  let(:access_with_duration) do
    FactoryBot.attributes_for(:access_with_duration, user: user)
  end
  let(:other_access_expires_at) do
    FactoryBot.attributes_for(:access_with_expires_at,
                              user: user,
                              package: access_with_expires_at[:package])
  end
  let(:other_access_duration) do
    FactoryBot.attributes_for(:access_with_duration,
                              user: user,
                              package: access_with_duration[:package])
  end
  let(:access_with_subscription) do
    FactoryBot.attributes_for(:access_with_subscription,
                              user: user)
  end

  describe '#create_user_access' do
    context 'with a valid order' do
      context 'without previous access' do
        context 'a package with an expire date' do
          it 'creates an access' do
            expect do
              access_create(access_with_expires_at[:order])
            end.to change(Access, :count).by(1)
            expect(validate_access(permalink, user)).to be_truthy
            Timecop.freeze(61.minutes.from_now)
            expect(validate_access(permalink, user)).to be_falsey
            user_state_transition_asserts(user.reload, :subscriber)
          end
        end
        context 'a subscription package' do
          it 'creates an access' do
            expect do
              access_create(access_with_subscription[:order])
            end.to change(Access, :count).by(1)
            expect(validate_access(permalink, user)).to be_truthy
            Timecop.freeze((subscription_extra_time + 11.minutes).from_now)
            expect(validate_access(permalink, user)).to be_falsey
            access = Access.last
            expect(access.expires_at.strftime('%Y%m%dT%H%M%S'))
              .to eq((access_with_subscription[:order]
                     .expires_at + subscription_extra_time)
                     .strftime('%Y%m%dT%H%M%S'))
            user_state_transition_asserts(user.reload, :subscriber)
          end
        end

        context 'a package with an duration' do
          it 'creates an access' do
            expect do
              access_create(access_with_duration[:order])
            end.to change(Access, :count).by(1)
            expect(validate_access(permalink, user)).to be_truthy
            Timecop.freeze(6.month.from_now.utc + 61.minutes)
            expect(validate_access(permalink, user)).to be_falsey
            user_state_transition_asserts(user.reload, :subscriber)
          end
        end
      end

      context 'buy twice' do
        context 'with expire date' do
          it 'returns access true only while it is valid' do
            access_create(access_with_expires_at[:order])
            expect(validate_access(permalink, user)).to be_truthy
            Timecop.freeze(10.minutes.from_now)
            access_create(other_access_expires_at[:order])
            Timecop.freeze(access_with_expires_at[:package]
            .expires_at + 1.minutes)
            expect(validate_access(permalink, user)).to be_falsey
            user_state_transition_asserts(user.reload, :subscriber)
          end
        end

        context 'with duration' do
          it 'returns access true only while it is valid' do
            access_create(access_with_duration[:order])
            expect(validate_access(permalink, user)).to be_truthy
            access_create(other_access_duration[:order])
            Timecop.freeze((Time.now + access_with_duration[:package]
              .duration.months) + 1.months)
            expect(validate_access(permalink, user)).to be_truthy
            Timecop.freeze((Time.now + other_access_duration[:package]
              .duration.months) + 1.minutes)
            expect(validate_access(permalink, user)).to be_falsey
            user_state_transition_asserts(user.reload, :subscriber)
          end
        end

        context 'buy tree times with duration' do
          it 'returns access true only while it is valid' do
            accesses = []
            accesses.push access_create(access_with_duration[:order])
            Timecop.freeze(3.months.from_now)
            accesses.push access_create(other_access_duration[:order])
            Timecop.freeze(1.months.from_now)
            accesses.push access_create(other_access_duration[:order])
            reset_time
            durations = accesses_durations(accesses)
            sum = sum_of(durations, :from_now)
            Timecop.freeze(sum - 5.hours)
            expect(validate_access(permalink, user)).to be_truthy
            reset_time
            Timecop.freeze(sum + 5.hours)
            expect(validate_access(permalink, user)).to be_falsy
            user_state_transition_asserts(user.reload, :subscriber)
          end
        end
      end
    end
    context 'with complementary accesses' do
      context 'with a main package' do
        let!(:main_package) { create(:package_valid_with_price) }
        context 'for only one complementary access' do
          context 'one child package' do
            let!(:child_package1) { create(:package_valid_with_price) }
            context 'an order' do
              let!(:order) do
                create(:order_valid,
                       package: main_package,
                       complementary_packages: [child_package1])
              end
              context 'and a complementary package' do
                let!(:complementary_package) do
                  create(:complementary_package,
                         package_id: main_package.id,
                         child_package_id: child_package1.id)
                end
                it 'asserts that all the accesses needed is created' do
                  access_create(order)
                  expect(Access.count).to eq 2
                  expect(Access.first.package).to eq main_package
                  expect(Access.second.package).to eq child_package1
                  user_state_transition_asserts(order.user.reload, :subscriber)
                end
              end
            end
          end
        end
        context 'for two complementary accesses' do
          context 'two child packages' do
            let!(:child_package1) { create(:package_valid_with_price) }
            let!(:child_package2) { create(:package_valid_with_price) }
            context 'an order' do
              let!(:order) do
                create(:order_valid,
                       package: main_package,
                       complementary_packages: [child_package1, child_package2])
              end
              context 'and two complementary packages' do
                let!(:complementary_package1) do
                  create(:complementary_package,
                         package_id: main_package.id,
                         child_package_id: child_package1.id)
                end
                let!(:complementary_package2) do
                  create(:complementary_package,
                         package_id: main_package.id,
                         child_package_id: child_package2.id)
                end
                it 'asserts that all the accesses needed is created' do
                  access_create(order)
                  expect(Access.count).to eq 3
                  expect(Access.first.package).to eq main_package
                  expect(Access.second.package).to eq child_package1
                  expect(Access.third.package).to eq child_package2
                  user_state_transition_asserts(order.user.reload, :subscriber)
                end
              end
            end
          end
        end
        context 'for three complementary accesses' do
          context 'three child packages' do
            let!(:child_package1) { create(:package_valid_with_price) }
            let!(:child_package2) { create(:package_valid_with_price) }
            let!(:child_package3) { create(:package_valid_with_price) }
            context 'an order' do
              let!(:order) do
                create(:order_valid,
                       package: main_package,
                       complementary_packages: [child_package1, child_package2, child_package3])
              end
              context 'and three complementary packages' do
                let!(:complementary_package1) do
                  create(:complementary_package,
                         package_id: main_package.id,
                         child_package_id: child_package1.id)
                end
                let!(:complementary_package2) do
                  create(:complementary_package,
                         package_id: main_package.id,
                         child_package_id: child_package2.id)
                end
                let!(:complementary_package3) do
                  create(:complementary_package,
                         package_id: main_package.id,
                         child_package_id: child_package3.id)
                end
                it 'asserts that all the accesses needed is created' do
                  access_create(order)
                  expect(Access.count).to eq 4
                  expect(Access.first.package).to eq main_package
                  expect(Access.second.package).to eq child_package1
                  expect(Access.third.package).to eq child_package2
                  expect(Access.fourth.package).to eq child_package3
                  user_state_transition_asserts(order.user.reload, :subscriber)
                end
              end
            end
          end
        end
      end
    end
  end

  describe 'update user access' do
    context '#subtract_user_access' do
      context 'with one access with expire date' do
        it 'should remove the access' do
          access = access_create(access_with_expires_at[:order])
          Timecop.freeze(access.package.expires_at - 5.minutes)
          expect(validate_access(permalink, user)).to be_truthy
          contest_access(access)
          Timecop.freeze(5.minutes.from_now)
          expect(validate_access(permalink, user)).to be_falsey
          user_state_transition_asserts(user.reload, :ex_subscriber)
        end
      end

      context 'with one access with duration' do
        it 'should remove the access' do
          access = access_create(access_with_duration[:order])
          assert_access_at(access.duration_in_months.from_now - 5.days, true)
          contest_access(access)
          assert_access_at(5.days.from_now, false)
          user_state_transition_asserts(user.reload, :ex_subscriber)
        end
      end

      context 'with two accesses' do
        context 'one shot' do
          context 'remove first access' do
            it 'should deduct the access duration' do
              accesses = []
              accesses.push access_create(access_with_duration[:order])
              Timecop.freeze(3.months.from_now)
              accesses.push access_create(other_access_duration[:order])
              reset_time
              assert_access_at(accesses.second.expires_at - 5.hours, true)
              reset_time
              Timecop.freeze(3.months.from_now + 2.days)
              contest_access(accesses.first)
              reset_time
              assert_access_at(6.months.from_now - 3.hours, true)
              assert_access_at(6.days.from_now, false)
              user_state_transition_asserts(user.reload, :subscriber)
            end
          end

          context 'remove second access' do
            it 'should deduct the access duration' do
              accesses = []
              accesses.push access_create(access_with_duration[:order])
              Timecop.freeze(3.minutes.from_now)
              accesses.push access_create(other_access_duration[:order])
              assert_access_at(5.minutes.from_now, true)
              Timecop.freeze(2.days.from_now)
              contest_access(accesses.second)
              reset_time
              assert_access_at(6.months.from_now - 3.days, true)
              assert_access_at(6.days.from_now, false)
              user_state_transition_asserts(user.reload, :subscriber)
            end
          end
        end
      end

      context 'with three accesses' do
        context 'one shot' do
          context 'remove middle access' do
            it 'should deduct the access duration' do
              accesses = []
              accesses.push access_create(access_with_duration[:order])
              Timecop.freeze(3.minutes.from_now)
              accesses.push access_create(other_access_duration[:order])
              Timecop.freeze(3.minutes.from_now)
              accesses.push access_create(other_access_duration[:order])
              reset_time
              assert_access_at(6.months.from_now + 6.months + 6.months - 5.hour, true)
              reset_time
              Timecop.freeze(10.minutes.from_now)
              contest_access(accesses.second)
              reset_time
              assert_access_at(6.months.from_now + 6.months - 3.hours, true)
              assert_access_at(6.days.from_now, false)
              user_state_transition_asserts(user.reload, :subscriber)
            end
          end
        end
      end

      context 'send mailers' do
        let(:access) { create(:access_with_duration) }

        context 'access with voucher' do
          let!(:voucher) { create(:voucher, access: access) }

          it 'send voucher email' do
            expect { contest_access(voucher.access) }
              .to change(ActionMailer::Base.deliveries, :count).by(1)
            user_state_transition_asserts(voucher.access.user.reload, :ex_subscriber)
          end
        end

        context 'access without voucher' do
          it 'not send voucher email' do
            expect { contest_access(access) }
              .to change(ActionMailer::Base.deliveries, :count).by(0)
            user_state_transition_asserts(access.user.reload, :ex_subscriber)
          end
        end
      end
    end

    context '#freeze' do
      it 'return freezed access with valid remaining days' do
        access = access_create(access_with_duration[:order])
        expect(validate_access(permalink, user)).to be_truthy
        Timecop.freeze(5.days.from_now)
        access.freeze
        expect(validate_access(permalink, user)).to be_falsey
        expect(access.remaining_days).to eq(remaining_days_for(access))
        user_state_transition_asserts(access.user.reload, :unsubscriber)
      end
    end

    context '#unfreeze' do
      it 'return unfreezed access with no remaining days' do
        access = access_create(access_with_duration[:order])
        expect(validate_access(permalink, user)).to be_truthy
        Timecop.freeze(30.days.from_now)
        access.freeze
        expect(validate_access(permalink, user)).to be_falsey
        Timecop.freeze(60.days.from_now)
        access.unfreeze
        expect(validate_access(permalink, user)).to be_truthy
        expect(access.remaining_days).to eq(0)
        user_state_transition_asserts(access.user.reload, :subscriber)
      end
    end

    context 'as admin' do
      it 'return valid access' do
        Timecop.freeze(Time.at(1_470_679_722))
        expect do
          create_gift(user, access_with_expires_at[:package], 6,
                      create(:admin))
        end.to change(Access, :count).by(1)
        expect(validate_access(permalink, user)).to be_truthy
        Timecop.freeze(6.days.from_now + 1.minutes)
        expect(validate_access(permalink, user)).to be_falsey
      end
    end
  end

  def accesses_durations(accesses)
    (0..accesses.length - 1).collect do |n|
      accesses[n].duration_in_months
    end
  end

  def assert_access_at(time, condition)
    Timecop.freeze(time)
    expect(validate_access(permalink, user)).to eq(condition)
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Access, type: :model do
  include UserAccessSpecHelper

  context 'validations' do
    should_be_present(:user_id, :package_id, :starts_at, :expires_at)
  end

  context 'scopes' do
    context '.active' do
      it 'returns only the active accesses' do
        active = create(:access_with_duration_and_node)
        create(:access_with_duration_and_node,
               active: false)

        expect(Access.active).to eq([active])
      end
    end

    context '.in_range' do
      it 'return the accesses in the range' do
        in_range = create(:access_with_duration_and_node,
                          starts_at: Time.now - 1.day)
        create(:access_with_duration_and_node,
               starts_at: Time.now + 1.day)

        expect(Access.in_range).to eq([in_range])
      end
    end

    context '.by_user' do
      it 'return user accesses' do
        user = create(:user)
        user_access = create(:access_with_duration_and_node,
                             user_id: user.id)
        create(:access_with_duration_and_node)
        expect(Access.by_user(user)).to eq([user_access])
      end
    end

    context '.by_package' do
      it 'return the accesses filtrated by package' do
        package = create(:package_with_duration,
                         node_ids: [create(:node).id])
        package_access = create(:access_with_duration_and_node,
                                package_id: package.id)
        create(:access_with_duration_and_node)
        expect(Access.by_package(package)).to eq([package_access])
      end
    end

    context '.valid' do
      it 'return the user accesses filtrated by package in range' do
        user = create(:user)
        package = create(:package_with_duration,
                         node_ids: [create(:node).id])
        access = create(:access_with_duration_and_node,
                        package_id: package.id,
                        user_id: user.id,
                        starts_at: Time.now - 1.day,
                        active: true)
        create(:access_with_duration_and_node,
               package_id: package.id,
               user_id: user.id,
               starts_at: Time.now - 1.day,
               active: false)
        create(:access_with_duration_and_node,
               package_id: package.id,
               user_id: user.id,
               starts_at: Time.now + 1.day)
        create(:access_with_duration_and_node,
               user_id: user.id,
               starts_at: Time.now - 1.day)
        create(:access_with_duration_and_node,
               package_id: package.id,
               starts_at: Time.now - 1.day)
        expect(Access.valid(user, package))
          .to eq([access])
      end
    end

    context '.by_user_active_in_range' do
      it 'return the user accesses filtrated by package in range' do
        user = create(:user)
        access = create(:access_with_duration_and_node,
                        user_id: user.id,
                        starts_at: Time.now - 1.day,
                        active: true)
        create(:access_with_duration_and_node,
               user_id: user.id,
               starts_at: Time.now - 1.day,
               active: false)
        create(:access_with_duration_and_node,
               user_id: user.id,
               starts_at: Time.now + 1.day)
        create(:access_with_duration_and_node,
               starts_at: Time.now - 1.day)
        expect(Access.by_user_active_in_range(user))
          .to eq([access])
      end
    end

    context '.paid_access_by_user_and_packages' do
      it 'return paid accesses' do
        user = create(:user)
        package = create(:package_with_expires_at,
                         node_ids: [create(:node).id])
        create(:gift_access_with_duration, package: package,
                                           user: user, gift: true)
        create(:access_with_expires_at)
        paid_access = create(:access_with_expires_at,
                             user: user,
                             package: package)
        expect(Access.paid_access_by_user_and_packages(user, [package.id]))
          .to eq([paid_access])
      end
    end
  end

  context 'create access' do
    it 'assert intercom worker was called' do
      mock_intercom_update_user
      expect(UpdateIntercomUserWorker).to receive(:perform_async)
      create(:access_with_duration_and_node)
    end

    it 'assert that the acess is created with the same' \
       'amount of essay credits as its package' do
      package = create(:package_valid_with_price)
      access = create(:access_with_duration, package_id: package.id)

      expect(access.essay_credits).to eq(package.essay_credits)
    end

    it 'assert that the acess is created with the same' \
       'amount of private class credits as its package' do
      package = create(:package_valid_with_price, :with_private_class_credits)
      access = create(:access_with_duration, package_id: package.id)

      expect(access.private_class_credits).to eq(package.private_class_credits)
    end

    it 'assert first expires is valid' do
      mock_intercom_update_user
      expect(UpdateIntercomUserWorker)
        .to receive(:perform_async).exactly(3).times
      user = create(:user)
      access = create(:access_with_duration_and_node, user: user)
      Timecop.freeze(Time.now + 1.day)
      create(:access_with_duration_and_node, user: user)
      Timecop.freeze(Time.now - 2.days)
      first_to_expire = create(:access_with_duration_and_node,
                               user: user)
      Timecop.freeze(Time.now + 1.days)

      expect(access.first_expiration_date.to_i)
        .to eq(first_to_expire.expires_at.to_i)
    end
  end

  context 'update access' do
    it 'freeze access should deactivate and fill remaining days' do
      user = create(:user)
      access = create(:access_with_duration_and_node, user: user)
      access.freeze

      expect(access.reload.active).to be_falsey
      expect(access.reload.remaining_days).not_to be_nil
      user_state_transition_asserts(user.reload, :unsubscriber)
    end

    it 'unfreeze access active access and reset remaining days' do
      user = create(:user)
      access = create(:access_with_duration_and_node,
                      user: user,
                      active: false,
                      remaining_days: 10)
      access.unfreeze

      expect(access.reload.active).to be_truthy
      expect(access.reload.remaining_days).to eq(0)
      user_state_transition_asserts(user.reload, :subscriber)
    end

    it 'deactivate access should deactivate' do
      user = create(:user)
      access = create(:access_with_duration_and_node,
                      user: user)
      access.deactivate

      expect(access.reload.active).to be_falsey
    end
  end

  context 'unique?' do
    context 'for a user' do
      let!(:user) { create(:user) }
      context 'with a package' do
        let!(:package) { create(:package_with_duration, node_ids: [create(:node).id]) }
        context 'and one valid access' do
          let!(:access) do
            create(:access_with_expires_at,
                   package: package,
                   user: user,
                   expires_at: Date.today + 60.days)
          end
          it 'returns true' do
            expect(access.unique?).to eq(true)
          end
        end
        context 'and two valid accesses' do
          let!(:access1) do
            create(:access_with_expires_at,
                   package: package,
                   user: user,
                   expires_at: Date.today + 60.days)
          end
          let!(:access2) do
            create(:access_with_expires_at,
                   package: package,
                   user: user,
                   expires_at: Date.today + 90.days)
          end
          it 'returns true' do
            expect(access1.unique?).to eq(false)
            expect(access2.unique?).to eq(false)
          end
        end
      end
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'
require 'me_salva/user/access'

RSpec.describe MeSalva::User::PremiumStatusValidator do
  subject { described_class }

  context 'student types definition' do
    context 'student_type' do
      context 'student_lead?' do
        context 'for a student_lead student type' do
          let!(:user) { create(:user) }
          it 'should return 0' do
            expect(subject.new(user).intercom_status).to eq(0)
          end
        end
      end
      context 'subscriber?' do
        context 'for a subscriber student type' do
          let!(:access) { create(:access_expiring_tomorow) }
          it 'should return 1' do
            expect(subject.new(access.user).intercom_status).to eq(1)
          end
        end
      end
      context 'unsubscriber?' do
        context 'for a unsubscriber student type' do
          let!(:access) { create(:access_expired) }
          it 'should return 2' do
            expect(subject.new(access.user).intercom_status).to eq(2)
          end
        end
      end
      context 'student_ex_subscriber?' do
        context 'for a ex_subscriber student type' do
          context 'with an expired access' do
            context 'for a refunded order' do
              let!(:access) { create(:expired_access_with_refunded_order) }
              it 'should return 3' do
                expect(subject.new(access.user).intercom_status).to eq(3)
              end
            end
            context 'for a subscription' do
              let!(:package) { create(:package_subscription) }
              let!(:access) do
                create(:access_with_subscription,
                       active: false,
                       expires_at: Date.yesterday,
                       package: package)
              end
              it 'should return 3' do
                expect(subject.new(access.user).intercom_status).to eq(3)
              end
            end
          end
        end
      end
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InstructorUsersWorker do
  context '#perform' do
    let!(:package) { create(:package_valid_with_price) }
    let!(:instructor) { create(:instructor, package_id: package.id) }
    let!(:user1) { create(:user) }
    let!(:user2) { create(:user) }
    let!(:user3) { create(:user) }
    let!(:crm_event1) do
      create(:crm_event,
             id: 8_800_001,
             user_id: user1.id,
             event_name: 'campaign_sign_up')
    end
    let!(:crm_event2) do
      create(:crm_event,
             id: 8_800_002,
             user_id: user2.id,
             event_name: 'campaign_sign_up')
    end
    let!(:crm_event3) do
      create(:crm_event,
             id: 8_800_003,
             user_id: user3.id,
             event_name: 'campaign_sign_up')
    end

    before do
      ENV['MESALVA_FOR_SCHOOLS_PACKAGE_ID'] = package.id.to_s
      ENV['MESALVA_FOR_SCHOOLS_PACKAGE_INTERVAL_IN_DAYS'] = "1"
      create(:utm,
             :quarantine,
             id: 13_600_001,
             referenceable_id: crm_event1.id,
             utm_content: instructor.user.token)
      create(:utm,
             :quarantine,
             id: 13_600_002,
             referenceable_id: crm_event2.id,
             utm_content: instructor.user.token)
      create(:utm,
             :quarantine,
             id: 13_600_003,
             referenceable_id: crm_event3.id,
             utm_content: instructor.user.token)
      instructor.users << user3

      user3.accesses << Access.new(
        user_id: user3.id,
        package_id: ENV['MESALVA_FOR_SCHOOLS_PACKAGE_ID'].to_i,
        starts_at: Time.now,
        expires_at: Time.now +
                ENV['MESALVA_FOR_SCHOOLS_PACKAGE_INTERVAL_IN_DAYS'].to_i.days,
        gift: true
      )
    end
    it 'returns the count of utm content referrals of the user' do
      expect { subject.perform }.to change(Access, :count).by(2)

      expect(
        user1.reload.accesses.pluck(:package_id)
      ).to include(instructor.package_id)
    end

    it 'creates a user for the instructor' do
      subject.perform

      expect(instructor.reload.users).not_to be_empty
      expect(instructor.reload.users).to include(user1)
      expect(instructor.reload.users).to include(user2)
    end

    context 'when instructor enters his own link' do
      let!(:crm_event_instructor) do
        create(:crm_event,
               user_id: instructor.user_id,
               event_name: 'campaign_sign_up')
      end

      before do
        create(:utm,
               :quarantine,
               id: 13_600_004,
               referenceable_id: crm_event_instructor.id,
               utm_content: instructor.user.token)
      end
      it 'does not set instructor as his own student' do
        subject.perform

        expect(instructor.reload.users.pluck(:id)).not_to include(instructor.id)
      end
    end

    context 'when running for a second time' do
      before do
        crm_event1.created_at = Date.yesterday
        crm_event1.save
      end

      it 'ignores already processed students' do
        expect { subject.perform }.to change(Access, :count).by(1)
      end
    end
  end
end

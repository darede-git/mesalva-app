# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CampaignEvent, type: :model do
  describe 'Validations' do
    context 'with the first campaign event valid' do
      let!(:campaign_event) { create(:campaign_event, :first_event) }
      it 'should be valid' do
        expect(campaign_event).to be_valid
      end
    end
    context 'with both campaign events valids' do
      let!(:campaign_event_event1) { create(:campaign_event, :first_event) }
      let!(:campaign_event_event2) { create(:campaign_event, :second_event) }
      it 'should be valid' do
        expect(campaign_event_event1).to be_valid
        expect(campaign_event_event2).to be_valid
      end
    end
    context 'without an user id' do
      let(:campaign_event) { build(:campaign_event, :first_event, user_id: nil) }
      it 'should be invalid' do
        expect(campaign_event).not_to be_valid
      end
    end
    context 'without a campaign name' do
      let(:campaign_event) { build(:campaign_event, :first_event, campaign_name: nil) }
      it 'should be invalid' do
        expect(campaign_event).not_to be_valid
      end
    end
    context 'without an event name' do
      let(:campaign_event) { build(:campaign_event, :first_event, event_name: nil) }
      it 'should be invalid' do
        expect(campaign_event).not_to be_valid
      end
    end
    context 'with a non-unique record' do
      it 'should be invalid' do
        create(:campaign_event,
               :first_event,
               user_id: 1)
        duplicated = FactoryBot.build(:campaign_event,
                                      :first_event,
                                      user_id: 1)
        expect(duplicated).not_to be_valid
      end
    end
  end
end

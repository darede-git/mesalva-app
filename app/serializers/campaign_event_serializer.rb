# frozen_string_literal: true

class CampaignEventSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :invited_by, :campaign_name, :event_name
end

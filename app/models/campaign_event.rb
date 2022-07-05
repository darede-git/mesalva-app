# frozen_string_literal: true

include QueryHelper

class CampaignEvent < ActiveRecord::Base
  belongs_to :user

  validates :user_id, :campaign_name, :event_name, presence: true

  validates_uniqueness_of :user_id, scope: %i[campaign_name event_name]

  def self.count_sequence(**data)
    CampaignEvent.connection.select_one(count_sequence_query(data)).to_hash
  end

  def self.count_sequence_query(data)
    invites_where = snt_sql(
      ["invited_by = :invited_by AND campaign_name = :campaign_name AND event_name = :event_name",
       { invited_by: data[:invited_by],
         campaign_name: data[:campaign_name],
         event_name: data[:event1] }]
    )
    campaign_events_where = snt_sql(["campaign_events.event_name = :event_name",
                                     { event_name: data[:event2] }])
    <<~SQL
      WITH invites AS (SELECT user_id, invited_by, event_name FROM campaign_events WHERE #{invites_where})
      SELECT COUNT(invites.user_id) event_1_count, COUNT(campaign_events.user_id) event_2_count FROM invites
      LEFT JOIN campaign_events ON invites.user_id = campaign_events.user_id AND #{campaign_events_where};
    SQL
  end

  private_class_method :count_sequence_query
end

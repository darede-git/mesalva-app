# frozen_string_literal: true

class UserSetting < ActiveRecord::Base
  include CommonModelScopes
  include RdStationHelper

  belongs_to :user

  validates :key, :user_id, presence: true

  after_save :send_rd_station_settings_event
  after_save :change_rd_station_settings_attribute

  private

  def send_rd_station_settings_event
    return if Rails.env.test?

    send_rd_station_event(event: :user_settings,
                          params: { user: user,
                                    key: key,
                                    value: value })
  end

  def change_rd_station_settings_attribute
    return if Rails.env.test?

    rd_user = MeSalva::Crm::Rdstation::Users.new(user)
    rd_user.update_attribute(key, value)
  end
end

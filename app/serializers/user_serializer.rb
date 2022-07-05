# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  include SerializationHelper

  has_one :address
  has_one :academic_info
  belongs_to :education_level
  belongs_to :objective
  attributes :provider, :uid,        :name,     :image,
             :email,    :birth_date, :gender,   :studies,
             :dreams,   :premium,    :origin,   :active,
             :created_at, :facebook_uid, :google_uid,
             :phone_area, :phone_number, :profile, :options,
             :token, :crm_email, :enem_subscription_id

  def id
    return object.id if try(:current_admin)

    object.uid
  end
end

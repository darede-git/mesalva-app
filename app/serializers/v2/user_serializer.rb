# frozen_string_literal: true

class V2::UserSerializer < V2::ApplicationSerializer
  set_id :uid
  has_one :address
  has_one :academic_info
  belongs_to :education_level
  belongs_to :objective

  attributes :provider, :name, :email, :birth_date, :gender, :studies, :dreams,
             :premium, :origin, :active, :created_at, :phone_area, :profile,
             :phone_number, :facebook_uid, :google_uid

  attribute :image do |object|
    object.image.serializable_hash
  end
end

# frozen_string_literal: true

class UserPlatformSerializer < ActiveModel::Serializer
  include SerializationHelper

  belongs_to :user
  belongs_to :platform

  attributes :role, :verified, :options, :active, :email, :user_name, :token, :platform_unity_id

  def email
    object.user.email
  end

  def user_name
    object.user.name
  end

  def id
    object.token
  end
end

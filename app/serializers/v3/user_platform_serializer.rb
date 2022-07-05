# frozen_string_literal: true

class V3::UserPlatformSerializer < V3::BaseSerializer
  attributes :role, :verified, :options, :active, :email, :user_name, :token, :platform_unity_id

  def email(object)
    object.user.email
  end

  def user_name(object)
    object.user.name
  end

  def id(object)
    object.token
  end
end

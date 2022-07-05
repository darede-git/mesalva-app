# frozen_string_literal: true

class V2::InstructorSerializer
  include FastJsonapi::ObjectSerializer

  belongs_to :user
  attributes :user_token

  attribute :user_token do |object|
    object.user.token
  end
end

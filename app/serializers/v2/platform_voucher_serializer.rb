# frozen_string_literal: true

class V2::PlatformVoucherSerializer
  include FastJsonapi::ObjectSerializer

  belongs_to :platform
  belongs_to :package
  has_one :user

  attributes :token, :email, :duration, :options
end

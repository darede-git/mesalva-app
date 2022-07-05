# frozen_string_literal: true

class PlatformVoucherSerializer < ActiveModel::Serializer
  attributes :token, :email, :options
  has_one :platform
  has_one :user
  has_one :package
end

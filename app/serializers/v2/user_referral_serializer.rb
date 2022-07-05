# frozen_string_literal: true

class V2::UserReferralSerializer
  include FastJsonapi::ObjectSerializer
  set_id :user_token
  attributes :confirmed_referrals
end

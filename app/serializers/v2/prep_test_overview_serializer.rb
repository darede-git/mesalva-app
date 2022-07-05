# frozen_string_literal: true

class V2::PrepTestOverviewSerializer
  include FastJsonapi::ObjectSerializer

  attributes :user_uid, :token, :score, :permalink_slug, :corrects, :answers
end

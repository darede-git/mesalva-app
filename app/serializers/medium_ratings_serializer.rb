# frozen_string_literal: true

class MediumRatingsSerializer
  include FastJsonapi::ObjectSerializer

  attributes :value
end

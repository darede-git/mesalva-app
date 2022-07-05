# frozen_string_literal: true

class V2::SchoolSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :uf, :city
end

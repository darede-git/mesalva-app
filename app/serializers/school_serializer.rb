# frozen_string_literal: true

class SchoolSerializer < ActiveModel::Serializer
  attributes :name, :uf, :city
end

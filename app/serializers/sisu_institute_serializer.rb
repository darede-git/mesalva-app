# frozen_string_literal: true

class SisuInstituteSerializer < ActiveModel::Serializer
  include SerializationHelper

  attributes :ies, :initials, :shift, :passing_score, :year, :semester
end

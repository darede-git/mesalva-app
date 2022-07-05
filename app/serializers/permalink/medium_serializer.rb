# frozen_string_literal: true

class Permalink::MediumSerializer < ActiveModel::Serializer
  attributes :slug, :medium_type, :listed
end

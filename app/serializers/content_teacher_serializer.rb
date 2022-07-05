# frozen_string_literal: true

class ContentTeacherSerializer < ActiveModel::Serializer
  attributes :name, :slug, :active, :description, :image, :avatar, :content_type
end

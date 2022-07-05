# frozen_string_literal: true

class V3::ContentTeacherSerializer < V3::BaseSerializer
  attributes :name, :slug, :image, :avatar, :email, :description, :content_type
end

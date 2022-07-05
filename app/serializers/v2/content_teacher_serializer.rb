# frozen_string_literal: true

class V2::ContentTeacherSerializer
    include FastJsonapi::ObjectSerializer
  
    attributes :name, :slug, :image, :avatar, :email, :description, :content_type
  end

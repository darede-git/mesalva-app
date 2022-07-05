# frozen_string_literal: true

class CommentSerializer < ActiveModel::Serializer
  belongs_to :commenter
  attributes :id, :text, :author_name, :created_at, :updated_at, :author_image

  def id
    object.token
  end
end

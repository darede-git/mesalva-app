# frozen_string_literal: true

class V2::MentoringSerializer
  include FastJsonapi::ObjectSerializer
  belongs_to :user
  belongs_to :content_teacher

  attributes :title, :active, :comment, :simplybook_id, :starts_at, :call_link, :category

  attribute :content_teacher do |object|
    {
      name: object.content_teacher.name,
      slug: object.content_teacher.slug,
      email: object.content_teacher.email,
      avatar: object.content_teacher.avatar
    }
  end

  attribute :user do |object|
    {
      name: object.user.name,
      uid: object.user.uid
    }
  end
end

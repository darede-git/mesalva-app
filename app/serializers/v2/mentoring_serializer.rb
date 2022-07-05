# frozen_string_literal: true

class V2::MentoringSerializer
  include FastJsonapi::ObjectSerializer
  belongs_to :user
  belongs_to :content_teacher

  attributes :title, :status, :comment, :starts_at, :simplybook_id, :call_link

  attribute :content_teacher do |object|
    {
      name: object.content_teacher.name,
      slug: object.content_teacher.slug,
      avatar: object.content_teacher.avatar
    }
  end
end

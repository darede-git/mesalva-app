# frozen_string_literal: true

class V3::MentoringSerializer < V3::BaseSerializer
  belongs_to :user
  belongs_to :content_teacher

  attributes :title, :status, :comment, :starts_at, :simplybook_id, :call_link
end

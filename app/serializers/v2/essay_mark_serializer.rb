# frozen_string_literal: true

class V2::EssayMarkSerializer < V2::ApplicationSerializer
  belongs_to :essay_submission

  attributes :description, :mark_type, :coordinate
end

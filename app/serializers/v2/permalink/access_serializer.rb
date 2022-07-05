# frozen_string_literal: true

class V2::Permalink::AccessSerializer
  include FastJsonapi::ObjectSerializer
  set_key_transform :dash

  attribute :permalink_slug, :status_code, :children

  set_id :permalink_slug
end

# frozen_string_literal: true

class Permalink::AccessSerializer < ActiveModel::Serializer
  attribute :permalink_access, key: 'permalink-access'

  def permalink_access
    { 'permalink-slug' => object.permalink_slug,
      'status-code' => object.status_code,
      'children' => object.children }
  end
end

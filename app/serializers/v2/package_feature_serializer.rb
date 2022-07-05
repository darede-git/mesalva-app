# frozen_string_literal: true

class V2::PackageFeatureSerializer < V3::BaseSerializer
  attributes :id, :name, :slug, :has

  def has(object)
    object.package_id.present?
  end
end

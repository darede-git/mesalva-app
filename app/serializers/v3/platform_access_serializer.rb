# frozen_string_literal: true

class V3::PlatformAccessSerializer < V3::BaseSerializer
  attributes :user_id, :active, :gift, :starts_at, :expires_at, :package

  def package(object)
    if object.respond_to?(:package_id)
      return { id: object.package_id, name: object.package_name, slug: object.package_slug }
    end
    pack = object.package
    { id: pack.id, name: pack.name, slug: pack.slug }
  end
end

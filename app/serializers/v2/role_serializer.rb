# frozen_string_literal: true

class V2::RoleSerializer
    include FastJsonapi::ObjectSerializer

    attributes :name, :slug, :description
end

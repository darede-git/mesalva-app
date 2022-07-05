# frozen_string_literal: true

class V3::RoleSerializer < V3::BaseSerializer
    attributes :name, :slug, :description, :users

    def users(object)
        object.users.map do |user|
            { name: user.name, uid: user.uid }
        end
    end
end

# frozen_string_literal: true

class V3::PlatformUnitySerializer < V3::BaseSerializer
    attributes :id, :name, :parents

    def parents(object)
        parents = []
        parent = object.parent
        return parents if parent.nil?
        begin
            parents << { id: parent.id, name: parent.name }
        end while (parent = parent.parent)
        parents.reverse
    end
end

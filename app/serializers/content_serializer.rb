# frozen_string_literal: true

class ContentSerializer < V3::BaseSerializer
  attributes :id, :name, :slug, :token, :text, :active, :listed, :created_by, :updated_by,
             :children, :video_id, :provider, :difficulty, :type, :options, :permalinks

  def video_id(object)
    respond_key('video_id', object)
  end

  def provider(object)
    respond_key('provider', object)
  end

  def difficulty(object)
    respond_key('dificulty', object)
  end

  def type(object)
    object.full_type
  end

  def text(object)
    respond_key('medium_text', object) || respond_key('description', object)
  end

  def children(object)
    object.active_children.map do |child|
      {
        name: child.name,
        token: child.token,
        id: child.id,
        active: child.active,
        listed: child.listed,
        type: child.full_type,
      }
    end
  end

  def permalinks(object)
    object.direct_permalinks.pluck(:slug)
  end
end

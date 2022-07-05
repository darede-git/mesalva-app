# frozen_string_literal: true

class Bff::Admin::ContentsController < Bff::Admin::BffAdminBaseController
  before_action :set_content

  def show
    @result = @content_manager.to_h
    set_image
    set_medium_fields
    @result['permalinks'] = @content.direct_permalinks.pluck(:slug)
    @result['children'] = children
    @result['parents'] = parents
    @result['full_type'] = @content.full_type
    render_results(@result)
  end

  def update
    @content_manager.update(update_params)
    render_results(@content)
  end

  private

  def set_image
    @result['image'] = @content.image&.url if @content.entity_type?(:node) || @content.entity_type?(:node_module)
  end

  def set_medium_fields
    return nil unless @content.entity_type?(:medium)

    @result['placeholder'] = @content.placeholder&.url
    @result['attachment'] = @content.attachment&.url
    @result['answers'] = @content.answers
  end

  def parents
    @content.parents.map do |parent|
      {
        id: parent.id,
        name: parent.name,
        token: parent.token,
        full_type: parent.full_type,
      }
    end
  end

  def children
    @content.direct_children.map do |child|
      {
        id: child.id,
        slug: child.slug,
        name: child.name,
        full_type: child.full_type,
        token: child.token,
      }
    end
  end

  def update_params
    params.merge(updated_by: current_admin.uid)
  end

  def set_content
    @content_manager = Bff::Contents::ContentPageAdapter.new(params[:token])
    @content = @content_manager.find_content_by_token
  end
end

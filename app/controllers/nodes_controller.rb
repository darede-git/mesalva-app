# frozen_string_literal: true

class NodesController < ApplicationController
  before_action -> { authenticate_permalink_access(%w[admin]) }
  before_action :set_node, only: %i[update destroy]

  include AuthorshipConcern
  include PermalinkBuildConcern
  include AlgoliaIndex
  include Cache
  include RemovableEntityRelativesConcern

  def create
    @node = Node.new(node_params.merge(platform_params))
    if @node.save
      render_created(@node)
    else
      render json: @node.errors.messages, status: :unprocessable_entity
    end
  end

  def update
    if @node.update(node_update_params.merge(platform_params))
      @node.sort_relatives(params[:node_module_ids_order])
      update_algolia_index(@node.parent) if @node.parent
      render_ok(@node)
    else
      render json: @node.errors.messages, status: :unprocessable_entity
    end
  end

  def destroy
    @node.destroy
    head :no_content
  end

  private

  def set_node
    @node = Node.find(params[:id])
  end

  def node_params
    params.permit(:name, :active, :description, :suggested_to, :pre_requisite,
                  :video, :image, :node_type, :color_hex, :created_by,
                  :updated_by, :parent_id, :position, :meta_description,
                  :meta_title, :listed, options: {})
  end

  def node_update_params
    node_params.merge(params.permit(node_module_ids: [], medium_ids: []))
  end

  def platform_params
    return { platform_id: @platform.id } if @platform

    {}
  end
end

# frozen_string_literal: true

class ItemsController < ApplicationController
  before_action -> { authenticate_permalink_access(%w[admin]) }, except: :streaming_index
  before_action :set_item, only: %i[update destroy]

  include AuthorshipConcern
  include PermalinkBuildConcern
  include Cache
  include RemovableEntityRelativesConcern
  include QueryHelper

  def create
    @item = Item.new(item_params.merge(platform_params))
    if @item.save
      render_created(@item)
    else
      render_unprocessable_entity(@item.errors.messages)
    end
  end

  def update
    if @item.update(item_update_params.merge(platform_params))
      @item.sort_relatives(params[:medium_ids_order])
      @item.rebuild_permalink if params[:medium_ids].present?
      render_ok(@item)
    else
      render_unprocessable_entity(@item.errors.messages)
    end
  end

  def destroy
    @item.destroy
    render_no_content
  end

  def streaming_index
    @items = streaming_items

    return render_ok(@items) unless @items.nil?

    render_no_content
  end

  private

  def streaming_items
    if current_user.nil?
      Item
        .where(starts_at_params)
        .where(ends_at_params)
        .where(item_type: 'streaming')
    else
      Item.by_user_access(current_user.id)
          .where(starts_at_params)
          .where(ends_at_params)
          .where(item_type: 'streaming')
    end
  end

  def starts_at_params
    return snt_sql(['items.starts_at >= ?', Date.today]) if params[:starts_at].nil?

    snt_sql(['items.starts_at >= ?', params[:starts_at]])
  end

  def ends_at_params
    snt_sql(['items.ends_at < ?', params[:ends_at]]) unless params[:ends_at].nil?
  end

  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.permit(
      :name, :description, :item_type, :free, :active,
      :code, :downloadable, :created_by, :updated_by,
      :streaming_status, :meta_description, :meta_title,
      :starts_at, :ends_at, :listed,
      node_module_ids: [], content_teacher_slugs: [], options: {}
    ).merge(public_document_info_attributes)
  end

  def public_document_info_attributes
    params.permit(
      public_document_info_attributes:
        %i[document_type teacher course major_id college_id]
    )
  end

  def item_update_params
    item_params.merge(params.permit(node_module_ids: [],
                                    medium_ids: []))
  end

  def platform_params
    return { platform_id: @platform.id } if @platform

    {}
  end
end

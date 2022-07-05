# frozen_string_literal: true

class ContentsController < ApplicationController
  before_action -> { authenticate_permalink_access(%w[user admin teacher]) }, only: :show
  before_action :authenticate_permission, only: :update
  before_action :set_content

  def show
    return render_not_found if @content.nil?

    render json: serialize_legacy.serializable_hash, status: :ok
  end

  private

  def set_content
    @content_manager = Bff::Contents::ContentPageAdapter.new(content_params[:token])
    @content = @content_manager.content
  end

  def serialize_legacy
    entity_serializer = "Content::#{@content.class.name}Serializer"
    entity_class = Object.const_get(entity_serializer)
    entity_class.new(@content)
  end

  def content_params
    params.permit(:token)
  end
end

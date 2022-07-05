# frozen_string_literal: true

class ImagesController < ApplicationController
  before_action :authenticate_permission
  before_action :set_image, only: [:destroy]

  def create
    @image = Image.new(create_image_params)
    if @image.save
      render_created(@image)
    else
      render_unprocessable_entity(@image.errors.messages)
    end
  end

  def destroy
    @image.destroy
    render_no_content
  end

  private

  def created_by
    return current_admin.uid if current_user.nil?

    current_user.uid
  end

  def set_image
    @image = Image.find(params[:id])
  end

  def create_image_params
    image_params.merge(
      created_by: created_by, platform_id: @platform&.id
    )
  end

  def image_params
    params.permit(:image)
  end
end

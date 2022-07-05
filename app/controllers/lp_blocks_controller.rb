# frozen_string_literal: true

class LpBlocksController < ApplicationController
  before_action -> { authenticate(%w[admin]) }
  before_action :set_lp_block, only: %i[show update destroy]

  def index
    lp_blocks = LpBlock.order(:id)
    render json: serialize_legacy(lp_blocks), status: :ok
  end

  def show
    if @lp_block
      render json: serialize_legacy(@lp_block), status: :ok
    else
      render_not_found
    end
  end

  def update
    if @lp_block.update(lp_block_params)
      render json: serialize_legacy(@lp_block), status: :ok
    else
      render_unprocessable_entity(@lp_block.errors.messages)
    end
  end

  def create
    @lp_block = LpBlock.new(lp_block_params)

    if @lp_block.save
      render json: serialize_legacy(@lp_block), status: :ok
    else
      render_unprocessable_entity(@lp_block.errors.messages)
    end
  end

  def destroy
    if @lp_block.update(active: false)
      render_no_content
    else
      render_unprocessable_entity(@lp_block.errors.messages)
    end
  end

  private

  def serialize_legacy(lp_block)
    LpBlockSerializer.new(lp_block).serialized_json
  end

  def set_lp_block
    @lp_block = if params[:id].nil?
                  LpBlock.where(type_of: params[:type_of], active: true)
                else
                  LpBlock.where(id: params[:id], active: true)
                end
  end

  def lp_block_params
    params.permit(:name, :type_of, :active, schema: {}, data: {})
  end
end

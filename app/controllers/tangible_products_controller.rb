# frozen_string_literal: true

class TangibleProductsController < ApplicationController
  before_action :authenticate_permission
  before_action :set_tangible_product, only: %i[show update destroy]

  def index
    tangible_products = TangibleProduct.page(page_param)
    render json: serialize(tangible_products), status: :ok
  end

  def show
    if @tangible_product
      render json: serialize(@tangible_product), status: :ok
    else
      render_not_found
    end
  end

  def create
    @tangible_product = TangibleProduct.new(tangible_product_params)
    if @tangible_product.save
      render json: serialize(@tangible_product), status: :created
    else
      render_unprocessable_entity(@tangible_product.errors)
    end
  end

  def update
    if @tangible_product.update(tangible_product_params)
      render json: serialize(@tangible_product), status: :ok
    else
      render_unprocessable_entity(@tangible_product.errors)
    end
  end

  def destroy
    if @tangible_product.destroy
      render_no_content
    else
      render_unprocessable_entity(@tangible_product.errors)
    end
  end

  private

  def set_tangible_product
    @tangible_product = TangibleProduct.find(tangible_product_params[:id])
  end

  def tangible_product_params
    params.permit(:id, :name, :height, :length, :width, :weight, :description, :sku, :imagem)
  end
end

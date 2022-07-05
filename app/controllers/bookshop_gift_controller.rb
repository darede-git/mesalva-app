# frozen_string_literal: true

class BookshopGiftController < ApplicationController
  before_action :authenticate_permission
  before_action :set_bookshop_gift, only: :index

  def index
    render json: serialize(@bookshop_gift, include: [:bookshop_gift_package]),
           status: :ok
  end

  def create
    @bookshop_gift = BookshopGift.new(create_bookshop_gift_params)

    if @bookshop_gift.save
      render json: serialize(@bookshop_gift, include: [:bookshop_gift_package]), status: :created
    else
      render_unprocessable_entity(@bookshop_gift.errors)
    end
  end

  private

  def set_bookshop_gift
    @bookshop_gift = BookshopGift.coupon_available.by_user(current_user).last
    return render_no_content if @bookshop_gift.nil?
  end

  def create_bookshop_gift_params
    params.permit(:bookshop_gift_package_id, :coupon)
  end
end

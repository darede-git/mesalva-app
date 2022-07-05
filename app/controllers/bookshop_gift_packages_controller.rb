# frozen_string_literal: true

class BookshopGiftPackagesController < ApplicationController
  before_action -> { authenticate(%w[admin]) }

  def index
    render json: serialize(available_coupons_by_package, params: { include_joined: true }), status: :ok
  end

  private

  def available_coupons_by_package
    BookshopGiftPackage.available_coupons_by_package.order(id: :desc)
  end
end

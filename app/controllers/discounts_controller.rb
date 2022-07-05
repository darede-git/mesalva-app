# frozen_string_literal: true

require 'me_salva/payment/discount'

class DiscountsController < ApplicationController
  before_action -> { authenticate(%w[admin]) }, only: %i[update create show]
  before_action -> { authenticate(%w[user]) }, only: :redeem
  before_action :set_discount, only: %i[update show]
  before_action :set_discount_by_code, only: [:redeem]
  before_action :set_package, only: [:redeem]

  include SerializationHelper
  include AuthorshipConcern

  def create
    discount = Discount.new(discount_create_params)
    if discount.save
      render_created(discount)
    else
      render_unprocessable_entity(discount.errors)
    end
  end

  def update
    if @discount.update(discount_params)
      render_ok(@discount)
    else
      render_unprocessable_entity(@discount.errors)
    end
  end

  def show
    render_ok(@discount)
  end

  def redeem
    if discount_valid?
      render_ok(@discount)
    else
      render_discount_invalid
    end
  end

  private

  def set_discount
    @discount = Discount.find_by_token(params[:id])
    render_not_found if @discount.nil?
  end

  def set_discount_by_code
    @discount = Discount.find_by_code(params[:code].try(:upcase))
  end

  def set_package
    @package = Package.find_by_slug(params[:package_slug])
  end

  def discount_valid?
    return false unless @package && @discount

    payment_discount_valid
  end

  def payment_discount_valid
    payment_discount.valid?(@package, @discount, current_user)
  end

  def payment_discount
    @payment_discount ||= MeSalva::Payment::Discount.new
  end

  def discount_params
    params.permit(:starts_at, :expires_at, :updated_by, :description,
                  :user_id, :only_customer, packages: [], upsell_packages: [])
  end

  def discount_create_params
    discount_params.merge(params.permit(:percentual, :name, :code, :created_by))
  end

  def render_discount_invalid
    render_unprocessable_entity(t('discount.invalid_discount'))
  end
end

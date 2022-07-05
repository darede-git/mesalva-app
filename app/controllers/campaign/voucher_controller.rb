# frozen_string_literal: true

require 'me_salva/user/access'

class Campaign::VoucherController < ApplicationController
  before_action -> { authenticate(%w[user]) }
  before_action :set_voucher

  def create
    if coupon_valid?
      access = create_access
      deactive_coupon(access)
      send_email
      render json: access, status: :created,
             serializer: AccessSerializer, include: :package, meta: meta
    else
      render_unprocessable_entity
    end
  end

  private

  def set_voucher
    @voucher = Voucher.find_by(token: params['token'],
                               active: true)
  end

  def coupon_valid?
    @voucher && another_user? && valid_date
  end

  def another_user?
    @voucher.user.id != current_user.id
  end

  def valid_date
    (@voucher.created_at + ENV['VOUCHER_DURATION_DAYS'].to_i.days) >= Time.now
  end

  def deactive_coupon(access)
    @voucher.update!(active: false, access: access)
  end

  def create_access
    MeSalva::User::Access.new.create(current_user,
                                     @voucher.order.package,
                                     order: @voucher.order)
  end

  def meta
    { created_by: @voucher.user.uid }
  end

  def send_email
    VoucherMailer.create_access_email(current_user).deliver_now
  end
end

# frozen_string_literal: true

module MeSalva
  module Campaign
    module Voucher
      class CouponGenerator
        def initialize(order)
          @order = order
        end

        def build
          return unless valid?

          create_coupon
          send_email
        end

        private

        def valid?
          date_valid? && package_valid?
        end

        def create_coupon
          @voucher = ::Voucher.create(order: @order,
                                      user: @order.user,
                                      campaign: 'fim_de_ano_2018')
        end

        def date_valid?
          @order.created_at.between?(start_at, expires_at)
        end

        def start_at
          convert_to_date(ENV['VOUCHER_STARTS_AT'])
        end

        def expires_at
          convert_to_date(ENV['VOUCHER_EXPIRES_AT'])
        end

        def convert_to_date(value)
          Time.strptime(value, '%d/%m/%Y %H:%M:%S')
        end

        def package_valid?
          packages_ids.include?(@order.package_id.to_s)
        end

        def packages_ids
          ENV['VOUCHER_PACKAGES'].split(',')
        end

        def send_email
          VoucherMailer.invitation_email(@order, @voucher.token)
                       .deliver_now
        end
      end
    end
  end
end

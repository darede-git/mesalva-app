# frozen_string_literal: true

module MeSalva
  module Campaign
    module Carnaval
      class DiscountGenerator
        PACKAGES = %w[2381 2382 142 190 130 182].freeze
        CAMPAIGN_NAME = 'Carnaval2018'
        STARTS_AT = '2018-02-07 00:00:00'
        EXPIRES_AT = '2018-02-21 00:00:00'
        DESCRIPTION = 'Campanha do carnaval de 2018 de descontos aleatórios'

        def initialize(user_id)
          @user_id = user_id
        end

        def build
          return campaign_discount if campaign_discount_already_exists?

          create_discount
          @discount
        end

        private

        def campaign_discount_already_exists?
          campaign_discount.present?
        end

        def campaign_discount
          @campaign_discount ||= Discount.find_by(name: CAMPAIGN_NAME,
                                                  user_id: @user_id)
        end

        def create_discount
          @discount = Discount.new(discount_attr)
          @discount.code = generate_token
          @discount.save!
        end

        def discount_attr
          { starts_at: STARTS_AT,
            expires_at: EXPIRES_AT,
            name: CAMPAIGN_NAME,
            percentual: percentual,
            description: DESCRIPTION,
            packages: PACKAGES,
            created_by: 'campaign',
            user_id: @user_id }
        end

        def generate_token
          @discount.generate_token(column: :code, converters: converters)
        end

        def converters
          lambda do |x|
            x.prepend('surpresa').upcase![0..15]
          end
        end

        def percentual
          case random_percentual
          when 0..30 then 20
          when 31..70 then 30
          when 71..80 then 40
          when 81..90 then 50
          when 91..96 then 60
          when 97..99 then 70
          when 100 then 80
          end
        end

        def random_percentual
          @random_percentual ||= Random.rand(1..100)
        end
      end
    end
  end
end

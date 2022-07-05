# frozen_string_literal: true

module MeSalva
  module Payment
    module Revenuecat
      class InitialPurchase < Postback
        def initialize(metadata = {})
          super(metadata)
        end
      end
    end
  end
end

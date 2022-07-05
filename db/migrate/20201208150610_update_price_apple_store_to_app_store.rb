# frozen_string_literal: true

class UpdatePriceAppleStoreToAppStore < ActiveRecord::Migration[5.2]
  def change
    execute("UPDATE prices SET price_type='app_store' WHERE price_type = 'apple_store'")
  end
end

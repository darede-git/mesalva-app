# frozen_string_literal: true

class AddOnlyCostumerToDiscounts < ActiveRecord::Migration[5.2]
  def change
    add_column :discounts, :only_costumer, :boolean, default: false
  end
end

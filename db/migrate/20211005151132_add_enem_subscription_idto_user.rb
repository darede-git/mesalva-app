# frozen_string_literal: true

class AddEnemSubscriptionIdtoUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :enem_subscription_id, :string
  end
end




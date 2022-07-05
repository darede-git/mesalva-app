# frozen_string_literal: true

class CreateUserReferrals < ActiveRecord::Migration[5.2]
  def change
    create_table :user_referrals do |t|
      t.references :user, foreign_key: true
      t.string :code
      t.timestamp :last_checked
      t.boolean :being_processed, default: false
      t.integer :confirmed_referrals, default: 0

      t.timestamps
    end
  end
end

# frozen_string_literal: true

class CreatePlatformVouchers < ActiveRecord::Migration[5.2]
  def change
    create_table :platform_vouchers do |t|
      t.references :platform, foreign_key: true
      t.string :token
      t.string :email
      t.integer :duration, nullable: false, default: 30
      t.references :user, foreign_key: true
      t.references :package, foreign_key: true
      t.jsonb :options, nullable: false, default: {}

      t.timestamps
    end
    add_index :platform_vouchers, :token, unique: true
  end
end

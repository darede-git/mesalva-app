class CreateUserCounters < ActiveRecord::Migration[5.2]
  def change
    create_table :user_counters do |t|
      t.string :period_type
      t.references :user, foreign_key: true
      t.string :period
      t.integer :video
      t.integer :text
      t.integer :exercise
      t.integer :public_document
      t.integer :essay
      t.integer :book

      t.timestamps
    end

    add_index :user_counters, [:period_type, :user_id, :period]
  end
end

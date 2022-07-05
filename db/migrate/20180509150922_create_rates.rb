class CreateRates < ActiveRecord::Migration[4.2]
  def change
    create_table :rates do |t|
      t.references :user, index: true, foreign_key: true
      t.references :playlist, index: true, foreign_key: true
      t.integer :value

      t.timestamps null: false
    end

    add_index :rates, [:user_id, :playlist_id], unique: true
  end
end

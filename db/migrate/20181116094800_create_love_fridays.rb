class CreateLoveFridays < ActiveRecord::Migration[4.2]
  def change
    create_table :love_fridays do |t|
      t.string :token, unique: true
      t.boolean :active, default: true
      t.references :user, index: true, foreign_key: true
      t.references :order, index: true, foreign_key: true
      t.references :access, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end

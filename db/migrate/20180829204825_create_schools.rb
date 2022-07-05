class CreateSchools < ActiveRecord::Migration[4.2]
  def change
    create_table :schools do |t|
      t.string :uf
      t.string :city
      t.string :name

      t.timestamps null: false
    end
  end
end

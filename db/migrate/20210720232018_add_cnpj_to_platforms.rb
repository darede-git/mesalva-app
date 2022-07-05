class AddCnpjToPlatforms < ActiveRecord::Migration[5.2]
  def change
    add_column :platforms, :cnpj, :string, nullable: true
    add_index :platforms, :cnpj, unique: true
  end
end

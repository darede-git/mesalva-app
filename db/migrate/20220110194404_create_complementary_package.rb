class CreateComplementaryPackage < ActiveRecord::Migration[5.2]
  def change
    create_table :complementary_packages do |t|
      t.references :package
      t.references :child_package, foreign_key: { to_table: :packages }
      t.integer :position
    end
  end
end

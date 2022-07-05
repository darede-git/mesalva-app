class AddComplementaryToPackages < ActiveRecord::Migration[5.2]
  def change
    add_column :packages, :complementary, :boolean, :default => false
  end
end

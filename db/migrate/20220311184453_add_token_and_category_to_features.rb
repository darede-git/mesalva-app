class AddTokenAndCategoryToFeatures < ActiveRecord::Migration[5.2]
  def change
    add_column :features, :token, :string
    add_column :features, :category, :string
  end
end

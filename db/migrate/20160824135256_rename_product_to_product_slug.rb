class RenameProductToProductSlug < ActiveRecord::Migration[4.2]
  def change
    rename_column :objectives, :product, :product_slug
  end
end

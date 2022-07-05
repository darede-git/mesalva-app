class AddSlugToMedia < ActiveRecord::Migration[4.2]
  def change
    add_column :media, :slug, :string
  end
end

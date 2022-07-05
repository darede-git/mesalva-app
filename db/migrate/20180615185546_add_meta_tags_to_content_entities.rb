class AddMetaTagsToContentEntities < ActiveRecord::Migration[4.2]
  def change
  	add_column :nodes, :meta_description, :text
  	add_column :nodes, :meta_title, :string

  	add_column :node_modules, :meta_description, :text
  	add_column :node_modules, :meta_title, :string

  	add_column :items, :meta_description, :text
  	add_column :items, :meta_title, :string
  end
end

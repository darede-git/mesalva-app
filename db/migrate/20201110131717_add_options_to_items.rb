class AddOptionsToItems < ActiveRecord::Migration[5.2]
  def change
    add_column :items, :options, :jsonb , default: {}
  end
end

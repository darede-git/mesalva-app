class AddsStreamingColumnsToItemsAndMedia < ActiveRecord::Migration[4.2]
  def change
  	add_column :items, :streaming_status, :string
  	add_column :items, :chat_token, :string
  	add_index :items, :chat_token, unique: true

  	add_column :media, :placeholder, :string
  end
end

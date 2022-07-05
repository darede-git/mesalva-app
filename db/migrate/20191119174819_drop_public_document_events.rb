class DropPublicDocumentEvents < ActiveRecord::Migration[5.2]
  def change
    remove_index :public_document_events, :public_document_info_id
    drop_table :public_document_events do |t|
      t.integer :user_id
      t.integer :public_document_info_id
      t.boolean :document_read, default: false
      t.integer :document_rating

      t.timestamps
    end
  end
end

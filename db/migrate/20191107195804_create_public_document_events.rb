class CreatePublicDocumentEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :public_document_events do |t|
      t.integer :user_id
      t.integer :public_document_info_id
      t.boolean :document_read, default: false
      t.integer :document_rating

      t.timestamps
    end
    add_index :public_document_events, :public_document_info_id
  end
end

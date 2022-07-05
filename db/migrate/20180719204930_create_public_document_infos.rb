class CreatePublicDocumentInfos < ActiveRecord::Migration[4.2]
  def change
    create_table :public_document_infos do |t|
      t.string :document_type
      t.string :teacher
      t.string :course
      t.references :major, index: true, foreign_key: true
      t.references :college, index: true, foreign_key: true
      t.references :item, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end

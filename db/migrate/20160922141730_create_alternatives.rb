class CreateAlternatives < ActiveRecord::Migration[4.2]
  def change
    create_table :alternatives do |t|
      t.text :text
      t.text :justification
      t.boolean :active
      t.boolean :correct
      t.belongs_to :medium, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end

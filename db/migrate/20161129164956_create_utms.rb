class CreateUtms < ActiveRecord::Migration[4.2]
  def change
    create_table :utms do |t|
      t.string :utm_source
      t.string :utm_medium
      t.string :utm_term
      t.string :utm_content
      t.string :utm_campaign
      t.references :referenceable, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end

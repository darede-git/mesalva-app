class CreateEssayEvent < ActiveRecord::Migration[4.2]
  def change
    create_table :essay_events do |t|
      t.string :event_name
      t.references :essay_submission, index: true, foreign_key: true
      t.integer :user_id
      t.string :user_name
      t.string :user_email
      t.string :correction_style
      t.string :essay_status
      t.string :permalink
      t.hstore :grades
      t.string :measurer_uid
      t.text :justification
      t.boolean :delayed
      t.timestamps null: false
    end
  end
end

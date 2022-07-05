class CreateEssaySubmissions < ActiveRecord::Migration[4.2]
  def change
    create_table :correction_styles do |t|
      t.string :correction_style
    end

    create_table :essay_submissions do |t|
      t.references :permalink, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.references :correction_style, index: true, foreign_key: true
      t.string :essay
      t.string :corrected_essay
      t.string :status
      t.boolean :active, default: true, null: false

      t.timestamps null: false
    end
  end
end

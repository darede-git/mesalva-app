class CreateQuizFormSubmissions < ActiveRecord::Migration[4.2]
  def change
    create_table :quiz_form_submissions do |t|
      t.belongs_to :quiz_form, index: true, foreign_key: true
      t.belongs_to :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end

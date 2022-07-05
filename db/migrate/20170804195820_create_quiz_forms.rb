class CreateQuizForms < ActiveRecord::Migration[4.2]
  def change
    create_table :quiz_forms do |t|
      t.string :name
      t.text :description
      t.boolean :active
      t.string :form_type

      t.timestamps null: false
    end
  end
end

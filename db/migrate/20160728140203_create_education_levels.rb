class CreateEducationLevels < ActiveRecord::Migration[4.2]
  def change
    create_table :education_levels do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end

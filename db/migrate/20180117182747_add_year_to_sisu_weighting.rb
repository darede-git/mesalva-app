class AddYearToSisuWeighting < ActiveRecord::Migration[4.2]
  def change
    add_column :sisu_weightings, :year, :string
    add_column :sisu_weightings, :semester, :string

    add_index :sisu_weightings, :year
    add_index :sisu_weightings, :semester

    add_index :sisu_institutes, :semester
  end
end

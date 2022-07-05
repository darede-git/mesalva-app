class AddIndexToSisuInstitute < ActiveRecord::Migration[4.2]
  def change
    add_index :sisu_institutes, :year
    add_index :sisu_institutes, :shift

    add_index :sisu_weightings, :shift
  end
end

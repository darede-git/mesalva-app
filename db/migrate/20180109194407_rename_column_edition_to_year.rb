class RenameColumnEditionToYear < ActiveRecord::Migration[4.2]
  def change
    rename_column :sisu_institutes, :edition, :year

    add_column :sisu_institutes, :semester, :string

    query = 'UPDATE sisu_institutes SET semester = SUBSTRING(year FROM 6 FOR 1)'
  	ActiveRecord::Base.connection.execute(query)

    query = 'UPDATE sisu_institutes SET year = SUBSTRING(year FROM 1 FOR 4)'
  	ActiveRecord::Base.connection.execute(query)
  end
end

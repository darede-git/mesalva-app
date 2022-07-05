class AddInepIdToSchools < ActiveRecord::Migration[5.2]
  def change
    add_column :schools, :inep_id, :integer
  end
end

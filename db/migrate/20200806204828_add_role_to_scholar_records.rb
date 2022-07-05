class AddRoleToScholarRecords < ActiveRecord::Migration[5.2]
  def change
    add_column :scholar_records, :user_role, :string
  end
end

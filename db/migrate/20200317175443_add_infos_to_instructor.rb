class AddInfosToInstructor < ActiveRecord::Migration[5.2]
  def change
    remove_column :instructors, :schools, :string, array: true
    remove_column :instructors, :subjects, :string, array: true
    remove_column :instructors, :students, :string

    add_column :instructors, :infos, :json
  end
end

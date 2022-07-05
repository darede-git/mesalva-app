class CreateCollegesMajorsJoinTable < ActiveRecord::Migration[4.2]
  def change
    create_join_table :colleges, :majors
  end
end

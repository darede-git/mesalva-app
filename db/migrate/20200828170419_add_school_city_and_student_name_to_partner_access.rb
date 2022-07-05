class AddSchoolCityAndStudentNameToPartnerAccess < ActiveRecord::Migration[5.2]
  def change
    add_column :partner_accesses, :school, :string
    add_column :partner_accesses, :city, :string
    add_column :partner_accesses, :student_name, :string
  end
end

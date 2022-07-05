class AddEducationLevelToPackage < ActiveRecord::Migration[4.2]
  def change
    add_reference :packages, :education_level, index: true, foreign_key: true
  end
end

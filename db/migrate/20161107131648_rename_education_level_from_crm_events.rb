class RenameEducationLevelFromCrmEvents < ActiveRecord::Migration[4.2]
  def change
    rename_column :crm_events, :package_education_level, :education_segment
  end
end

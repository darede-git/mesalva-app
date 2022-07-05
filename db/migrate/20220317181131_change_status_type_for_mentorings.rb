class ChangeStatusTypeForMentorings < ActiveRecord::Migration[5.2]
  def change
    change_column :mentorings, :status, :string
  end
end

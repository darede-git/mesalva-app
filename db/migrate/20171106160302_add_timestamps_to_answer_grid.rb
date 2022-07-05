class AddTimestampsToAnswerGrid < ActiveRecord::Migration[4.2]
  def change
    add_column :answer_grids, :submission_id, :integer
    add_column :answer_grids, :created_at, :datetime
    add_column :answer_grids, :updated_at, :datetime
  end
end

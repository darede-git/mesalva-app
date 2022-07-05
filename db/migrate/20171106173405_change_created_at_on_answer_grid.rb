class ChangeCreatedAtOnAnswerGrid < ActiveRecord::Migration[4.2]
  def change
    query = 'UPDATE answer_grids SET created_at = now(), updated_at = now()'
  	ActiveRecord::Base.connection.execute(query)

    change_column_null(:answer_grids, :created_at, false)
    change_column_null(:answer_grids, :updated_at, false)
  end
end

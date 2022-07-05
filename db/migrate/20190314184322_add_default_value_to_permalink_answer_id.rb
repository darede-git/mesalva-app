class AddDefaultValueToPermalinkAnswerId < ActiveRecord::Migration[5.2]
  def change
    change_column_default :permalink_events, :permalink_answer_id, 0
  end
end

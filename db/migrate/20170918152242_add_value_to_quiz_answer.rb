class AddValueToQuizAnswer < ActiveRecord::Migration[4.2]
  def change
    add_column :quiz_answers, :value, :string
  end
end

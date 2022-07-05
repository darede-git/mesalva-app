class AddActiveToQuizAlternative < ActiveRecord::Migration[5.2]
  def change
    add_column :quiz_alternatives, :active, :boolean, default: true
  end
end

class AddFeedbackToEssayEvents < ActiveRecord::Migration[5.2]
  def change
    rename_column :essay_events, :justification, :feedback
    add_column :essay_events, :correction_type, :string, default: 'redacao-padrao'
    add_column :essay_events, :uncorrectable_message, :string
  end
end

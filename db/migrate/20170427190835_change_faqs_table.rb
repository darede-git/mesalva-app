class ChangeFaqsTable < ActiveRecord::Migration[4.2]
  def change
  	change_column :faqs, :created_by, :string
  	change_column :faqs, :updated_by, :string
  end
end

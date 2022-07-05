class ChangeColumnTypeFaqs < ActiveRecord::Migration[4.2]
  def change
  	remove_column :faqs, :created_by
  	add_column :faqs, :created_by, :integer
  	remove_column :faqs, :updated_by
  	add_column :faqs, :updated_by, :integer
  end
end

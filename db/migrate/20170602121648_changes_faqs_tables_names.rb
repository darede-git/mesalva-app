class ChangesFaqsTablesNames < ActiveRecord::Migration[4.2]
  def change
  	rename_column :faqs, :question, :title
  	rename_column :faqs, :faq_topic_id, :faq_id
  	rename_table :faqs, :questions
  	rename_table :faq_topics, :faqs
  	add_index :faqs, :token
  end
end

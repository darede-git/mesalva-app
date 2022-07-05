class AddFaqTopicsToFaqs < ActiveRecord::Migration[4.2]
  def change
    add_reference :faqs, :faq_topic, foreign_key: true
  end
end

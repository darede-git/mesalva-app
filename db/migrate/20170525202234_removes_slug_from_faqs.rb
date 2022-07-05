class RemovesSlugFromFaqs < ActiveRecord::Migration[4.2]
  def change
  	remove_column :faqs, :slug
  end
end

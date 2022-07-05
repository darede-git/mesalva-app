class AddsSlugFaqs < ActiveRecord::Migration[4.2]
  def change
  	add_column :faqs, :slug, :string
  end
end

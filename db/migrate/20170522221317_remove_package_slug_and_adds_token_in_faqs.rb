class RemovePackageSlugAndAddsTokenInFaqs < ActiveRecord::Migration[4.2]
  def change
  	remove_column :faqs, :package_slug
  	add_column :faqs, :token, :string
  end
end

class ChangesPlatformNameAndTypeOnPackages < ActiveRecord::Migration[4.2]
  def change
  	remove_column :packages, :platform
  	add_column :packages, :sales_platforms, :string, array: true
  	query = 'UPDATE packages
						SET sales_platforms = \'{"web"}\''
		ActiveRecord::Base.connection.execute(query)
  end
end

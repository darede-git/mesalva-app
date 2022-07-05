# frozen_string_literal: true

class AddPackageTypeToPackages < ActiveRecord::Migration[5.2]
  def change
    add_column :packages, :package_type, :string
  end
end

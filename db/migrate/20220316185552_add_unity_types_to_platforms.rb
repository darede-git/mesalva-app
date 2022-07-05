class AddUnityTypesToPlatforms < ActiveRecord::Migration[5.2]
  def change
    add_column :platforms, :unity_types, :string, array: true, default: '{Unidade}'
  end
end

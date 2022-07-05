class AddModalityColumnsToSisuInstitutes < ActiveRecord::Migration[5.2]
  def change
    add_column :sisu_institutes, :trans, :boolean, default: false
    add_column :sisu_institutes, :indigena, :boolean, default: false
    add_column :sisu_institutes, :deficiencia, :boolean, default: false
    add_column :sisu_institutes, :publica, :boolean, default: false
    add_column :sisu_institutes, :carente, :boolean, default: false
    add_column :sisu_institutes, :afro, :boolean, default: false
  end
end

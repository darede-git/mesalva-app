class AddEmailToAcquisition < ActiveRecord::Migration[4.2]
  def change
    add_column :acquisitions, :email, :string
    add_column :acquisitions, :cpf, :string
    add_column :acquisitions, :nationality, :string
  end
end

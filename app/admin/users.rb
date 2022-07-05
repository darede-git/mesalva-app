# frozen_string_literal: true

ActiveAdmin.register User do
  actions :index, :show
  permit_params :name, :birth_date, :gender
  menu label: 'Estudantes', parent: 'Relacionamento'

  index do
    selectable_column
    id_column
    column :provider
    column :uid
    column :name
    column :email
    column :created_at
    column :active
    actions
  end

  filter :provider
  filter :uid
  filter :email
end

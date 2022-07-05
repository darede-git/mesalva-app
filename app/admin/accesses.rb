# frozen_string_literal: true

ActiveAdmin.register Access do
  actions :index, :show, :new, :create
  menu label: 'Acessos', parent: 'Relacionamento'

  permit_params :user_id, :package_id, :expires_at, :gift, :starts_at

  index do
    selectable_column
    id_column
    column :user_id
    column :order_id
    column :package_id
    column :starts_at
    column :expires_at
    column :active
    column :created_at
    column :created_by
    column :gift
    actions
  end

  filter :user_id
  filter :order_id
  filter :package_id
  filter :expires_at
  filter :created_at
  filter :gift

  form do |f|
    f.object.gift = true
    f.object.starts_at = Time.now
    f.inputs do
      f.input :user_id
      f.input :package_id
      f.input :starts_at, as: :date_time_picker
      f.input :expires_at, as: :date_time_picker
      f.input :gift, input_html: { value: true, disabled: true }
      f.actions
    end
  end
end

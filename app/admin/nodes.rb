# frozen_string_literal: true

ActiveAdmin.register Node do
  actions :index, :show, :update, :edit, :new, :create
  permit_params :name, :active, :description,
                :position, :node_type, :image, :color_hex
  menu label: 'Nodes', parent: 'Conteúdo'

  index do
    selectable_column
    id_column
    column :name
    column :slug
    column :active
    column :created_at
    column :ancestry
    actions
  end

  filter :id
  filter :name
  filter :slug
  filter :created_at
  filter :ancestry

  form do |f|
    f.inputs do
      f.input :name
      f.input :active
      f.input :description
      f.input :position

      if f.object.new_record?
        f.input :image
        f.input :color_hex
        f.input :node_type, as: :select, collection: Node::NODE_TYPES
      end
    end
    f.actions
  end
end

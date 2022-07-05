# frozen_string_literal: true

ActiveAdmin.register NodeModuleItem do
  actions :index, :show, :update, :edit, :new, :create
  permit_params :position, :item_id, :node_module_id
  menu label: 'NodeModule - Item', parent: 'Conteúdo'

  index do
    selectable_column
    id_column
    column :node_module_id
    column :item_id
    column :created_at
    column :position
    actions
  end

  filter :node_module_id
  filter :item_id

  form do |f|
    f.inputs do
      if f.object.new_record?
        f.input :item_id
        f.input :node_module_id
      end

      f.input :position
    end
    f.actions
  end
end

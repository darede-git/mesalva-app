# frozen_string_literal: true

ActiveAdmin.register Package do
  actions :index, :show, :update, :edit, :new, :create
  permit_params :name, :active, :listed, :duration, :max_payments,
                :subscription, :education_segment_slug, :play_store_product_id,
                :pagarme_plan_id, :app_store_product_id,
                sales_platforms: [],
                node_ids: [],
                prices_attributes: %i[id value price_type currency active]

  menu label: 'Pacotes', parent: 'Conversão'

  index do
    selectable_column
    id_column
    column :name
    column :slug
    column :expires_at
    column :active
    column :created_at
    column :subscription
    column :max_payments
    column :listed
    column :education_segment_id
    column :sales_platform do |p|
      p.sales_platforms.join(", ")
    end
    actions
  end

  filter :id
  filter :name
  filter :slug
  filter :created_at
  filter :active
  filter :subscription
  filter :listed
  filter :education_segment_slug

  form do |f|
    f.inputs do
      f.input :name
      f.input :active
      f.input :sales_platforms, as: :select,
                                multiple: true,
                                collection: Package::SALES_PLATFORMS
      f.input :pagarme_plan_id, label: 'Pagarme Plan - Subscriptions Only'
      f.input :app_store_product_id
      f.input :play_store_product_id
      f.input :listed
      if f.object.new_record?
        f.input :duration
        f.input :max_payments
        f.input :subscription
        f.input :education_segment_slug,
                as: :select,
                collection: Node.education_segments.pluck(:slug)
      end
      f.input :node_ids, as: :tags,
                         collection: Node.all,
                         value: :id,
                         display_name: :id_and_name
    end
    f.inputs do
      f.has_many :prices,
                 heading: 'Prices',
                 new_record: 'Add New Price',
                 allow_destroy: false do |b|
                   b.input :id, input_html: { disabled: true }
                   b.input :price_type, as: :select,
                                        collection: Price::PRICE_TYPES
                   b.input :value, input_html: { disabled: false }
                   b.input :currency, input_html: { disabled: true }
                   b.input :active
                 end
    end
    f.actions
  end

  controller do
    def edit
      @resource = Package.find params[:id]
      super
    end

    def show
      @resource = Package.find params[:id]
      super
    end
  end
end

class AddsCreatedByUpdatedByInTestimonials < ActiveRecord::Migration[4.2]
  def change
  	add_column :testimonials, :created_by, :string
  	add_column :testimonials, :updated_by, :string
  end
end

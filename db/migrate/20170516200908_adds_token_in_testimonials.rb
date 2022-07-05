class AddsTokenInTestimonials < ActiveRecord::Migration[4.2]
  def change
  	add_column :testimonials, :token, :string
  end
end

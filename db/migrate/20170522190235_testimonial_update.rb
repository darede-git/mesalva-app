class TestimonialUpdate < ActiveRecord::Migration[4.2]
  def change
  	rename_column :testimonials, :testimonial, :testimonial_text
  	rename_column :testimonials, :name, :user_name
  end
end

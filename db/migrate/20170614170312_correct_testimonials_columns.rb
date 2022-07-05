class CorrectTestimonialsColumns < ActiveRecord::Migration[4.2]
  def change
  	rename_column :testimonials, :testimonial_text, :text
  	rename_column :testimonials, :educational_segment_slug, :education_segment_slug
  end
end

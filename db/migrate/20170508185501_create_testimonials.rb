class CreateTestimonials < ActiveRecord::Migration[4.2]
  def change
    create_table :testimonials do |t|
      t.string :educational_segment_slug
      t.string :avatar
      t.string :name
      t.string :email
      t.string :phone
      t.boolean :sts_authorization
      t.boolean :marketing_authorization
      t.text :testimonial

      t.timestamps null: false
    end
  end
end

class AddCourseStructureSummaries < ActiveRecord::Migration[5.2]
  def change
    create_table :course_structure_summaries do |t|
      t.string :name
      t.string :slug
      t.boolean :active
      t.boolean :listed, default: true
      t.boolean :highlighted, default: false
      t.integer :position, default: true
      t.boolean :is_single_template
      t.integer :per_page

      t.string :selling_banner_name
      t.string :selling_banner_slug
      t.string :selling_banner_background_color
      t.string :selling_banner_background_image
      t.string :selling_banner_price_subtitle
      t.string :selling_banner_base_price
      t.string :selling_banner_checkout_button_label
      t.string :selling_banner_video
      t.string :selling_banner_infos, array: true
      t.string :selling_banner_package_slug

      t.string :events_title
      t.json :events_contents

      t.string :panel_highlights_image
      t.string :panel_highlights_color
      t.string :panel_highlights_name
      t.string :panel_highlights_button_text
      t.string :panel_highlights_premium_button_text

      t.string :essay_text
      t.string :essay_permalink

      t.boolean :description_card_hide
      t.string :description_card_title
      t.string :description_card_image
      t.string :description_card_text
      t.string :description_card_cta_href
      t.string :description_card_cta_text
      t.string :description_card_cta_premium_text

      t.timestamps
    end
  end
end

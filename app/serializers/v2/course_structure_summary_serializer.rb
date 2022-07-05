# frozen_string_literal: true

class V2::CourseStructureSummarySerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :slug,
             :active, :listed, :highlighted, :is_single_template, :per_page,
             :selling_banner_name, :selling_banner_slug,
             :selling_banner_background_color, :selling_banner_background_image,
             :selling_banner_price_subtitle, :selling_banner_base_price,
             :selling_banner_checkout_button_label, :selling_banner_video,
             :selling_banner_infos, :selling_banner_package_slug,
             :events_title, :events_contents,
             :panel_highlights_image, :panel_highlights_color,
             :panel_highlights_name, :panel_highlights_button_text,
             :panel_highlights_premium_button_text,
             :essay_text, :essay_permalink,
             :description_card_hide, :description_card_title,
             :description_card_image, :description_card_text,
             :description_card_cta_href, :description_card_cta_text,
             :description_card_cta_premium_text
end

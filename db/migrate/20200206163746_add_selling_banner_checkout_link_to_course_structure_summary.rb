class AddSellingBannerCheckoutLinkToCourseStructureSummary < ActiveRecord::Migration[5.2]
  def change
    add_column :course_structure_summaries, :selling_banner_checkout_link, :string
  end
end

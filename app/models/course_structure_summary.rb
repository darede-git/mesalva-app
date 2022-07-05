# frozen_string_literal: true

class CourseStructureSummary < ActiveRecord::Base
  validates_presence_of :active
  validates_inclusion_of :listed, in: [true, false]
  validate :if_slug_exists_is_unique

  def if_slug_exists_is_unique
    return true if slug.nil?

    return slug_already_exists_error if CourseStructureSummary.where(slug: slug)
                                                              .any?

    false
  end

  private

  def slug_already_exists_error
    errors.add(:meta_description,
               I18n.t(
                 'errors.course_structure_summary.slug_must_be_unique'
               ))
    false
  end
end

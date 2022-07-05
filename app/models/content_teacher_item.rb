# frozen_string_literal: true

class ContentTeacherItem < ActiveRecord::Base
  belongs_to :item
  belongs_to :content_teacher
end

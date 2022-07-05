# frozen_string_literal: true

class SisuScore < ActiveRecord::Base
  belongs_to :users
  belongs_to :quiz_form_submission
end

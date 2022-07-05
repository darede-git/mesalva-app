# frozen_string_literal: true

class Utm < ActiveRecord::Base
  belongs_to :referenceable, polymorphic: true
end

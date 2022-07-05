# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PermalinkSuggestion, type: :model do
  context 'validations' do
    should_be_present(:slug, :suggestion_slug, :suggestion_name)
  end
end

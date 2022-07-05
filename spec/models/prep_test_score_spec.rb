# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PrepTestScore, type: :model do
  context 'validations' do
    should_be_present(:submission_token, :user, :score, :permalink_slug)
  end
end

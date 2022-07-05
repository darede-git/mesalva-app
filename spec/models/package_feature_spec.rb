# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PackageFeature, type: :model do
  context 'validations' do
    should_belong_to(:package, :feature)

    it do
      create :package_feature
      is_expected.to validate_uniqueness_of(:package_id).scoped_to(:feature_id)
    end
  end
end

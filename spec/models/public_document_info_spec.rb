# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PublicDocumentInfo, type: :model do
  context 'validations' do
    should_belong_to(:item, :major, :college)

    it do
      should validate_inclusion_of(:document_type)
        .in_array(%w[test summary mind_map text_book book schoolwork])
    end
  end
end

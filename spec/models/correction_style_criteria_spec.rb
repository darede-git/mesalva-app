# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CorrectionStyleCriteria, type: :model do
  context 'validations' do
    it { should belong_to(:correction_style) }
  end
end

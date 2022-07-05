# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DesignSystem::Grid do
  subject { described_class.new }

  context 'with right props' do
    it 'should render component with default values' do
      subject.children = %w[Child1 Child2]
      subject.columns = "2fr 1fr"
      expect(subject.to_h).to eq({ component: "Grid",
                                   children: %w[Child1 Child2],
                                   columns: "2fr 1fr" })
    end
  end
end

# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DesignSystem::Text do
  subject { described_class.new }

  context 'with right props' do
    it 'should render component with default values' do
      subject.children = 'Some Text'
      subject.size = :sm
      expect(subject.to_h).to eq({
                                   component: "Text",
                                   children: 'Some Text',
                                   size: :sm
                                 })
    end
  end
end

# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DesignSystem::SectionCard do
  subject { described_class.new }

  context 'with right props' do
    it 'should render component with default values' do
      subject.title = 'Title'
      subject.children = 'Some children'
      expect(subject.to_h).to eq({
                                   component: "SectionCard",
                                   title: 'Title',
                                   children: 'Some children'
                                 })
    end
  end
end

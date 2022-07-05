# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DesignSystem::Button do
  subject { described_class.new }

  context 'with right props' do
    it 'should render component with default values' do
      subject.children = 'Text'
      subject.variant = :primary
      subject.size = :sm
      subject.disabled = true
      subject.icon_name = 'apple'
      subject.href = 'https://www.mesalva.com'
      expect(subject.to_h).to eq({
                                   component: "Button",
                                   children: 'Text',
                                   disabled: true,
                                   href: "https://www.mesalva.com",
                                   icon_name: "apple",
                                   size: :sm,
                                   variant: :primary
                                 })
    end
  end
end

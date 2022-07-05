# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DesignSystem::DisableStudyPlanButton do
  subject { described_class.new }

  context 'with right props' do
    it 'should render component with default values' do
      subject.label = 'Text'
      subject.variant = :primary
      subject.size = :sm
      subject.disabled = true
      subject.study_plan_id = 10
      expect(subject.to_h).to eq({
                                   component: "DisableStudyPlanButton",
                                   label: 'Text',
                                   variant: :primary,
                                   disabled: true,
                                   size: :sm,
                                   study_plan_id: 10
                                 })
    end
  end
end

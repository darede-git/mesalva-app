# frozen_string_literal: true

STUDY_PLAN =
  { full:
    { count: 20,
      node_module_ids: [208, 92, 490, 104, 88, 774, 560, 463, 776, 484,
                        723, 68, 91, 713, 48, 85, 127, 746, 385, 45],
      weeks: 4 },
    demo:
    { count: 14,
      node_module_ids: [208, 92, 490, 104, 173, 88, 774,
                        560, 463, 776,  484, 723, 68, 91],
      weeks: 2 } }.freeze

RSpec.shared_examples 'a default study plan from form submission' do |type|
  it 'creates a new study plan for the user' do
    expect do
      subject.build
    end.to change(StudyPlan, :count)
      .by(1)
      .and change(StudyPlanNodeModule, :count)
      .by(STUDY_PLAN[type][:count])

    last_study_plan = StudyPlan.last

    expect(StudyPlanNodeModule.where(study_plan_id: last_study_plan.id)
      .order(:id).pluck(:node_module_id))
      .to eq(STUDY_PLAN[type][:node_module_ids])

    expect(
      last_study_plan.study_plan_node_modules.map(&:completed).uniq
    ).to eq [false]

    expect(last_study_plan.start_date.strftime('%Y-%m-%d'))
      .to eq "2019-02-27"

    expect(last_study_plan.end_date.strftime('%Y-%m-%d'))
      .to eq "2019-03-27"

    expect(last_study_plan.estimated_weeks).to eq(STUDY_PLAN[type][:weeks])
  end
end

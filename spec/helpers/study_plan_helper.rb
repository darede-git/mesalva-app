# frozen_string_literal: true

module StudyPlanHelper
  def mock_keep_completed_modules_with(condition)
    allow_any_instance_of(MeSalva::StudyPlan::Answers)
      .to receive(:keep_completed_modules?)
      .and_return(condition)
  end

  def shift_positions
    {
      sunday: { morning: 0, mid: 1, evening: 2 },
      monday: { morning: 3, mid: 4, evening: 5 },
      tuesday: { morning: 6, mid: 7, evening: 8 },
      wednesday: { morning: 9, mid: 10, evening: 11 },
      thursday: { morning: 12, mid: 13, evening: 14 },
      friday: { morning: 15, mid: 16, evening: 17 },
      saturday: { morning: 18, mid: 19, evening: 20 }
    }
  end
end

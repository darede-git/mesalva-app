# frozen_string_literal: true

class AcademicInfoSerializer < ActiveModel::Serializer
  attributes :agenda, :current_school, :current_school_courses,
             :desired_courses, :school_appliances, :school_appliance_this_year,
             :favorite_school_subjects, :difficult_learning_subjects,
             :current_academic_activities, :next_academic_activities
end

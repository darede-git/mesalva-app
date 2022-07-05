# frozen_string_literal: true

class ScholarRecordSerializer < ActiveModel::Serializer
  belongs_to :user
  belongs_to :major
  belongs_to :college
  belongs_to :school

  attributes :education_level, :level_concluded, :study_phase, :school_name,
             :school_id, :school_city, :school_uf

  def school_name
    return object.school.name unless object.school.nil?
  end

  def school_id
    return object.school.id unless object.school.nil?
  end

  def school_city
    return object.school.city unless object.school.nil?
  end

  def school_uf
    return object.school.uf unless object.school.nil?
  end
end

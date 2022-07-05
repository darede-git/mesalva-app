# frozen_string_literal: true

class ScholarRecordsController < ApplicationController
  before_action -> { authenticate(%w[user]) }
  before_action :set_scholar_records, only: %i[index disable]
  before_action :last_scholar_record, only: %i[create disable]

  def index
    render_ok(@scholar_records)
  end

  def create
    scholar_record = ScholarRecord.new(scholar_record_params)
    if scholar_record.save
      disable_last_scholar
      render_created(scholar_record)
    else
      render_unprocessable_entity(scholar_record.errors)
    end
  end

  def disable
    if disable_last_scholar
      render_ok(@last_scholar_record)
    else
      render_not_found
    end
  end

  private

  def set_scholar_records
    @scholar_records = ScholarRecord.by_user(current_user)
  end

  def scholar_record_params
    params.merge(user_id: current_user.id)
          .permit(:education_level, :level_concluded, :major_id, :school_id,
                  :college_id, :study_phase, :active, :user_id, :user_role)
  end

  def last_scholar_record
    @last_scholar_record = set_scholar_records.last
  end

  def disable_last_scholar
    @last_scholar_record&.update(active: false)
  end
end

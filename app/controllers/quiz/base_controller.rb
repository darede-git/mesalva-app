# frozen_string_literal: true

class Quiz::BaseController < ApplicationController
  before_action :authenticate_admin, except: %i[show index]
  before_action :set_quiz_entity, except: %i[edit create index
                                             last_user_submission]

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  def index
    @quiz_entities = model.all
    render_ok(@quiz_entities)
  end

  def show
    render_ok(@quiz_entity)
  end

  def create
    @quiz_entity = model.new(quiz_entity_params)

    if @quiz_entity.save
      render_created(@quiz_entity)
    else
      render_unprocessable_entity(@quiz_entity.errors.messages)
    end
  end

  def update
    if @quiz_entity.update(quiz_entity_params)
      render_ok(@quiz_entity)
    else
      render_unprocessable_entity(@quiz_entity.errors.messages)
    end
  end

  def destroy
    @quiz_entity.destroy
    render_no_content
  end

  private

  def set_quiz_entity
    @quiz_entity = model.find(params[:id])
  end
end

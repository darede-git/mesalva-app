# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action -> { authenticate(%w[admin]) }, except: :show
  before_action :set_question_by_token, only: %i[update destroy show]

  include AuthorshipConcern

  def show
    if @question
      render_ok(@question)
    else
      render_not_found
    end
  end

  def create
    @question = Question.new(question_parameters)
    if @question.save
      render json: @question, status: :created
    else
      render_unprocessable_entity
    end
  end

  def update
    if @question.update(question_parameters)
      render json: @question, status: :ok
    else
      render_unprocessable_entity
    end
  end

  def destroy
    @question.destroy
    render_no_content
  end

  private

  def question_parameters
    params.permit(:title, :answer, :image, :created_by, :updated_by)
          .tap { |p| merge_faq(p) }
  end

  def merge_faq(p)
    p[:faq] = Faq.find_by_token(params[:faq_id])
  end

  def set_question_by_token
    @question = Question.find_by_token(params[:id])
  end
end

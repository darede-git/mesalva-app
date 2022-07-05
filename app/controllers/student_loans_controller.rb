# frozen_string_literal: true

class StudentLoansController < ApplicationController
  before_action -> { authenticate(%w[admin]) }, only: :create

  def create
    return render_unprocessable_entity(student_loan.errors.messages) if student_loan.errors.present?

    render_created(student_loan)
  end

  private

  def student_loan
    @student_loan ||= MeSalva::Billing::StudentLoan
                      .new(order_params, params[:user_uid])
                      .created_student_loan
  end

  def order_params
    params.permit(:package_id, :broker, :price_paid)
  end
end

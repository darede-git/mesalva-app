# frozen_string_literal: true

class OrderState
  include Statesman::Machine
  extend UserAccessHelper

  state :pending, initial: true
  state :paid
  state :canceled
  state :expired
  state :invalid
  state :refunded
  state :not_found
  state :pre_approved

  transition from: :pending, to: %i[paid invalid expired
                                    canceled not_found pre_approved]

  transition from: :paid, to: %i[refunded not_found]

  transition from: :pre_approved, to: :paid

  transition from: :pre_approved, to: %i[expired canceled refunded]
  
  before_transition() do |model|
    @model = model
  end

  before_transition(to: :paid) do |model|
    allow_access_flow unless model.status == 8
  end

  after_transition(to: :refunded) do |model|
    model.accesses.each do |access|
      contest_access(access)
    end
  end

  after_transition(to: %i[canceled invalid]) do |model|
    ::CrmRdstationPaymentRefusedWorker.perform_async(model.id)
  end

  after_transition do |model, transition|
    model.save_status_with_string(transition.to_state)
  end

  after_transition(from: :pre_approved, to: :expired) do |order|
    order.accesses.each do |access|
      contest_access(access)
    end
  end

  # rubocop:disable Style/SymbolProc
  guard_transition(from: :pending, to: :pre_approved) do |order|
    order.bank_slip? && order.payment_proof
  end
  # rubocop:enable Style/SymbolProc

  after_transition(from: :pending, to: :pre_approved) do |order|
    allow_access_flow
  end

  def self.allow_access_flow
    create_access(@model.user, @model.package, order: @model)
    MeSalva::Campaign::Voucher::CouponGenerator.new(@model).build
    create_payment_success_worker
  end

  def self.create_payment_success_worker
    ::CrmRdstationPaymentSuccessWorker.perform_async(@model.id)
  end

  private_class_method :create_payment_success_worker, :allow_access_flow
end

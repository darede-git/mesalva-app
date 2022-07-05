# frozen_string_literal: true

class User::ProfilesController < BaseProfilesController
  include AddressConcern
  include CrmEvents

  serialization_scope :current_admin
  before_action -> { authenticate(%w[admin user]) }
  before_action :set_resource
  after_action :set_resource_authorization
  after_action :disable_last_scholar_record, only: %i[update]

  def update
    return not_found unless @resource
    return forbidden if unpermitted_attributes?

    set_resource
    create_objective_change_event if objective_with_education_slug?
    super
  end

  def show
    return not_found unless @resource
    return forbidden if unpermitted_attributes?

    set_resource
    super
  end

  private

  def objective_with_education_slug?
    return false unless params["objective_id"]

    Objective.with_education_slug.collect(&:id)
             .include? params["objective_id"].to_i
  end

  def create_objective_change_event
    PersistCrmEventWorker.perform_async(crm_objective_change_params)
    CrmRdstationObjectiveChangeEventWorker.perform_in(
      1.second, @resource.uid, params["objective_id"].to_i
    )
  end

  def crm_objective_change_params
    crm_event_params('objective_change', @resource)
  end

  def unpermitted_attributes?
    return false if current_admin

    current_role && invalid_fields?
  end

  def not_found
    @resource = current_admin
    render_not_found
  end

  def forbidden
    @resource = current_user
    render_forbidden
  end

  def role_params
    return update_params.push(:email) if current_user.email.blank?

    update_params
  end

  def update_params
    %i[name image birth_date gender studies dreams phone_area phone_number
       objective_id education_level_id origin profile address_attributes enem_subscription_id
       academic_info_attributes net_promoter_scores_attributes options crm_email]
  end

  def valid_params
    [:provider, :uid, :name, :image, :email, :birth_date, :gender, :studies,
     :enem_subscription_id, :dreams, :biography, :objective_id, :iugu_customer_id, :premium,
     :education_level_id, :active, :phone_area, :phone_number, :profile, :crm_email, :origin,
     { academic_info_attributes: academic_info_attributes,
       address_attributes: address_attributes_with_id,
       net_promoter_scores_attributes: %i[score reason],
       options: %i[main_platform_id] }]
  end

  def academic_info_attributes
    %i[id agenda current_school current_school_courses
       desired_courses school_appliances school_appliance_this_year
       favorite_school_subjects difficult_learning_subjects
       current_academic_activities next_academic_activities]
  end

  def address_attributes_with_id
    address_attributes.push(:id)
  end

  def disable_last_scholar_record
    return if current_user.nil?

    current_user.disable_last_scholar_record if current_user.change_objective?
  end
end

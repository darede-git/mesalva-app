# frozen_string_literal: true

class BaseProfilesController < ApplicationController
  abstract!
  include SerializationHelper
  include IntercomHelper
  include AlgoliaIndex

  def update
    if @resource.update(profile_params)
      intercom_action if intercom_resource?
      update_algolia_index(@resource) if algolia_attributes?
      render_success
    else
      render_unprocessable_entity(@resource.errors)
    end
  end

  def show
    render_success
  end

  private

  def intercom_action
    return update_intercom_resource if profile_params['active'].nil?

    return destroy_intercom_user(@resource) if deactiving?

    update_intercom_user(@resource) if intercom_resource?
  end

  def update_intercom_resource
    return update_intercom_user(@resource) unless update_intercom_attributes?

    update_intercom_user_attributes
  end

  def update_intercom_user_attributes
    intercom_attributes = user_attributes.symbolize_keys
    intercom_attributes[:phone] = complete_phone_number if phone_attributes?
    update_intercom_user(@resource, intercom_attributes)
  end

  def phone_attributes?
    %i[phone_number phone_area].all? { |field| profile_params[field] }
  end

  def complete_phone_number
    "#{profile_params[:phone_area]} #{profile_params[:phone_number]}"
  end

  def attribute_column_name
    { education_level_id: :education_level_name, objective_id: :objective_name }
  end

  def attribute_intercom_name
    { education_level_name: 'education', objective_name: 'objetivo_mesalva' }
  end

  def user_attributes
    %w[education_level_id objective_id].each_with_object({}) do |value, result|
      result.merge!(attributes_to_update(value)) if profile_params[value].present?
    end
  end

  def attributes_to_update(column_name)
    { attribute_key(column_name) => attribute_value(column_name) }
  end

  def attribute_key(column_name)
    attribute_intercom_name[attribute_column_name[column_name.to_sym]]
  end

  def attribute_value(column_name)
    @resource.public_send(attribute_column_name[column_name.to_sym])
  end

  def update_intercom_attributes?
    return true if phone_attributes?

    %w[objective_id education_level_id].any? do |attr|
      profile_params[attr].present?
    end
  end

  def deactiving?
    profile_params['active'] == false
  end

  def render_success
    render json: @resource,
           include: %i[address academic_info education_level objective],
           status: :ok
  end
end

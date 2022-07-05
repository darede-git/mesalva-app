# frozen_string_literal: true

class PackagesController < ApplicationController
  include Cache

  before_action -> { authenticate(%w[admin]) }, only: %i[create update]
  before_action :authenticate_permission, only: %i[features]
  before_action -> { authenticate(%w[admin]) }, only: [:index],
                unless: :filters_are_present?
  before_action :set_package, only: %i[show update update_bookshop_gift features]
  after_action :verify_resource_authorization, only: %i[create update show]
  before_action :set_bookshop_gift_package, only: :update_bookshop_gift

  def index
    render_packages \
     if stale?(etag: filtered_packages,
               public: true,
               template: false,
               last_modified: last_update_for(packages))
  end

  def filter
    packages = Package.full_filters(filter_params)
                      .page(page_param).order(order_param)
    render json: serialize(packages, params: { simplified: true }), status: :ok
  end

  def show
    render json: @package, include: [:prices, :bookshop_gift_packages, :complementary_packages], status: :ok
  end

  def create
    @package = Package.new(package_params)
    if @package.save
      update_child_package_ids
      meta = broker_action
      render json: @package,
             include: :prices,
             meta: meta,
             status: :created
    else
      render_unprocessable_entity(@package.errors)
    end
  end

  def update
    return render_method_not_allowed if node_update? && node_removed?

    if @package.update(package_params)
      update_child_package_ids
      update_bookshop_link
      update_child_packages

      meta = broker_action
      render json: @package,
             include: :prices,
             meta: meta,
             status: :ok
    else
      render_unprocessable_entity(@package.errors)
    end
  end

  def update_bookshop_gift
    if @bookshop_gift_package.update(bookshop_gift_package_params)
      render_ok(@bookshop_gift_package)
    else
      render_unprocessable_entity(@bookshop_gift_package.errors)
    end
  end

  def features
    render json: serialize(package_features, v: 2, serializer: 'PackageFeature'), status: :ok
  end

  private

  def package_features
    Feature.with_package_id(@package.id)
  end

  def bookshop_gift_package_params
    params.permit(:package_id)
  end

  def set_bookshop_gift_package
    return render_unprocessable_entity unless @package.present? && new_package?

    @bookshop_gift_package = BookshopGiftPackage.find_by_package_id(@package.id)
  end

  def new_package?
    Package.where(id: params['package_id']).count.positive?
  end

  def update_child_package_ids
    return nil if params[:child_package_ids].nil?

    @package.child_package_ids = params[:child_package_ids]
  end

  def update_bookshop_link
    return if params[:bookshop_link].nil?
    BookshopGiftPackage.where(package: @package).update(params.permit(:bookshop_link))
  end

  def update_child_packages
    return if params[:child_package_ids].nil?
    @package.child_package_ids = params[:child_package_ids]
  end

  def render_packages
    render json: packages, include: :prices, status: :ok
  end

  def verify_resource_authorization
    update_auth_headers if authorized_role?(%w[admin user])
  end

  def set_package
    @package = Package.find_by_slug(params[:slug])
    return render_not_found unless @package
    @package
  end

  def filter_params
    params.permit(:like_name, :duration, :active, :education_segment_slug,
                  :sku, :unlimited_essay_credits, :complementary, :subscription)
  end

  def package_params
    params.merge(education_segment_id: education_segment_id)
          .permit(:name, :form, :expires_at, :form,
                  :duration, :active, :subscription, :listed,
                  :max_payments, :description, :position, :slug, :pagarme_plan_id,
                  :education_segment_slug, :education_segment_id, :sku,
                  :essay_credits, :private_class_credits, :tangible_product_id,
                  :tangible_product_discount_percent, :unlimited_essay_credits, :package_type, :complementary,
                  label: [], sales_platforms: [], info: [], node_ids: [],
                  feature_ids: [], prices_attributes: prices_attributes,
                  bookshop_gift_packages_attributes: bookshop_gift_packages_attributes)
  end

  def education_segment_id
    Node.find_by_slug(params['education_segment_slug']).try(:id)
  end

  def broker_action
    return unless send("package_valid_on_#{action}?")

    begin
      plan_response = MeSalva::Billing::Plan.send(action, package: @package)
      plan_response.to_hash
    rescue StandardError => e
      notify_engineers(e)
    end
  end

  def action
    params[:action].to_s
  end

  def package_valid_on_create?
    @package.subscription && @package.pagarme_plan_id.nil?
  end

  def package_valid_on_update?
    @package.subscription && @package.pagarme_plan_id.present?
  end

  def price
    @price ||= Price.find_by_package_id(@package.id)
  end

  def prices_attributes
    %i[id price_type value]
  end

  def bookshop_gift_packages_attributes
    %i[id package_id active bookshop_link _destroy]
  end

  def packages
    @packages ||= begin
                    return packages_by_education_segment_and_platform if filters_are_present?
                    return packages_by_education_segment if filtered_by_education_segment?
                    return packages_by_platform if filtered_by_platform?

                    Package.all
                  end
  end

  def filtered_packages
    { filter_key => packages }.to_json
  end

  def filter_key
    "#{params[:education_segment_slug]}-#{params[:platform]}"
  end

  def packages_by_education_segment
    Package.by_education_segment_slug(params[:education_segment_slug])
  end

  def packages_by_education_segment_and_platform
    Package.by_education_segment_slug_and_platform(
      params[:education_segment_slug], params[:platform]
    )
  end

  def packages_by_platform
    Package.by_platform(params[:platform])
  end

  def notify_engineers(exception)
    errors = ::Errors.new(StandardError.new)
    errors.notify_engineers(
      "Package #{@package.id} could not be saved remotely: #{exception.message}", { user_token: current_user&.token }
    )
  end

  def filtered_by_education_segment?
    params.key?('education_segment_slug')
  end

  def filtered_by_platform?
    params.key?('platform')
  end

  def filters_are_present?
    params.key?('education_segment_slug') && params.key?('platform')
  end

  def node_update?
    package_params[:node_ids].present?
  end

  def node_removed?
    current_nodes = @package.node_ids
    param_nodes = package_params[:node_ids].map(&:to_i)
    diff_nodes = current_nodes - param_nodes
    diff_nodes.any?
  end
end

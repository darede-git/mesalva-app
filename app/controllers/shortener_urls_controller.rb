# frozen_string_literal: true

class ShortenerUrlsController < ApplicationController
  include Shortener::ShortenerHelper
  include QueryHelper

  before_action -> { authenticate(%w[user]) }
  before_action :permit_params_index,
                :set_category,
                :set_start_date,
                :set_end_date,
                :set_expiration_date_existent, only: :index
  before_action :permit_params_create,
                :set_url, only: :create
  before_action :set_token, only: :create

  def index
    page = params['page'] || 1

    @shortened_urls = shortened_urls.page(page)
    render json: @shortened_urls, status: :ok
  end

  def show
    @shortened_url = Shortener::ShortenedUrl.find_by_unique_key(params[:token])
    if @shortened_url
      render json: @shortened_url, status: :ok
    else
      render_not_found
    end
  end

  def create
    return render_unprocessable_entity unless url_info_ok?

    @shortened_url = { shortened_url: find_or_create }
    render json: @shortened_url, status: :ok
  end

  private

  def set_url
    @url = define_url
  end

  def set_token
    @token = @params_permited[:token]
  end

  def set_category
    @category = @params_permited[:category]
  end

  def set_start_date
    @start_date = @params_permited[:start_date]
  end

  def set_end_date
    @end_date = @params_permited[:end_date]
  end

  def set_expiration_date_existent
    @expiration_date_existent = @params_permited[:expiration_date_existent]
  end

  def permit_params_index
    @params_permited = params.permit(:user_id,
                                     :category,
                                     :start_date,
                                     :end_date,
                                     :expiration_date_existent)
  end

  def permit_params_fetch_url
    @params_permited = params.permit(:token)
  end

  def permit_params_create
    @params_permited = params.permit(:url, :token)
  end

  def url_info_ok?
    @url.present?
  end

  def token_info_ok?
    @token.present?
  end

  def find_or_create
    short_url(@url, owner: current_user, custom_key: @token)
  end

  def shortened_urls
    Shortener::ShortenedUrl.where(user_id_filter)
                           .where(category_filter)
                           .where(expiration_filter)
  end

  def user_id_filter
    return nil if @params_permited[:user_id].nil?

    snt_sql(["owner_id = ?", @params_permited[:user_id]])
  end

  def category_filter
    return nil if params[:category].nil?

    snt_sql(["category = ?", @params_permited[:category]])
  end

  def expiration_filter
    return nil unless date_filter?

    return snt_sql(["expires_at between ? and ?", @start_date, @end_date]) if between_dates_filter?

    return snt_sql(["expires_at = ?", only_existent_date]) if equal_to_date_filter?

    return snt_sql(["expires_at IS NULL"]) unless existent_date_filter?

    return snt_sql(["expires_at IS NOT NULL"]) if existent_date_filter?
  end

  def date_filter?
    at_least_one_date? || @expiration_date_existent.present?
  end

  def between_dates_filter?
    @start_date.present? && @end_date.present?
  end

  def equal_to_date_filter?
    exactly_one_date? || equal_dates?
  end

  def existent_date_filter?
    ActiveModel::Type::Boolean.new.cast(@expiration_date_existent)
  end

  def at_least_one_date?
    @start_date.present? || @end_date.present?
  end

  def exactly_one_date?
    (@start_date.present? && @end_date.nil?) || (@start_date.nil? && @end_date.present?)
  end

  def equal_dates?
    (@start_date == @end_date) && @start_date.present?
  end

  def only_existent_date
    @start_date.present? ? @start_date : @end_date
  end

  def define_url
    return unless url_present?

    return url_with_ssl if valid_url?

    complete_url
  end

  def url_present?
    @params_permited[:url].present?
  end

  def valid_url?
    url_with_ssl.start_with?(ENV['DEFAULT_URL'])
  end

  def complete_url
    "#{ENV['DEFAULT_URL']}#{slash}#{@params_permited[:url]}"
  end

  def slash
    return '/' unless @params_permited[:url].start_with? '/'
  end

  def url_with_ssl
    @params_permited[:url].sub('http:', 'https:')
  end
end

# frozen_string_literal: true

module PaginationHelper
  def page_param(page = 1)
    return page unless params[:page].present?

    params[:page].to_i
  end

  def order_param(default_order = 'id DESC')
    return default_order unless params[:order_by].present?
    params[:order_by]
  end

  def per_page_param(per_page = 20)
    unless params[:per_page].present?
      return @per_page = per_page
    end

    @per_page = params[:per_page].to_i
  end

  def pagination_meta(model)
    {
      page: page_param,
      total_pages: model.total_pages,
      per_page: model.per_page
    }
  end
end

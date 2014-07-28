class ApiController < ApplicationController
  before_action :authenticate_user_with_api_token!

  def current_page
    params[:page] || params[:p] || 1
  end
  helper_method :current_page

  def current_limit
    limit = params[:limit] || params[:l] || Kaminari.config.default_per_page

    limit > Kaminari.config.max_per_page ? Kaminari.config.max_per_page : limit
  end
  helper_method :current_limit

  def current_offset
    (current_page - 1) * current_limit
  end
  helper_method :current_offset

  def search_results(search)
    ActiveRecord::Base.transaction(isolation: :repeatable_read) do
      results   = search.result.page(current_page).per(current_limit).all
      available = search.result.count
      returned  = results.length
      remaining = available - returned - current_offset

      return results, {
        page: current_page,
        limit: current_limit,
        offset: current_offset,
        returned: returned,
        available: available,
        remaining: remaining
      }
    end
  end

  private


  def authenticate_user_with_api_token!
    api_token = request.headers['X-API-TOKEN']

    # authenticate with api token
    if api_token.present?
      current_user = User.find_by_api_token(api_token)

      if current_user.present?
        @current_user = current_user
      end

    # authenticate with browser session
    else
      self.class.protect_from_forgery with: :exception
      authenticate_user!
    end
  end
end
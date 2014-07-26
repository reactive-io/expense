class ApiController < ApplicationController
  before_action :authenticate_user_with_api_token!
  before_action :authenticate_user!

  def current_page
    params[:page] || params[:p] || 1
  end

  def current_limit
    limit = params[:limit] || params[:l] || Kaminari.config.default_per_page

    limit > Kaminari.config.max_per_page ? Kaminari.config.max_per_page : limit
  end

  def current_offset
    (current_page - 1) * current_limit
  end

  def search_results(search)
    ActiveRecord::Base.transaction(isolation: :repeatable_read) do
      results = search.result.page(current_page).per(current_limit).all

      returned  = results.length
      available = search.result.count
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
    token = request.headers['X-API-TOKEN']

    if token.present?
      user = User.find_by_api_token(token)

      if user.present?
        sign_in user, store: false
      end
    end
  end
end
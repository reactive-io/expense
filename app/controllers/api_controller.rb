class ApiController < ApplicationController
  class InvalidApiToken < Exception; end

  protect_from_forgery with: :exception, unless: lambda { request.headers['X-API-TOKEN'] }

  before_action :authenticate_user_with_api_token!

  rescue_from InvalidApiToken do
    render json: {error: 'Invalid API Token'}, status: :bad_request
  end

  private

  def authenticate_user_with_api_token!
    api_token = request.headers['X-API-TOKEN']

    # authenticate with api token
    if api_token
      @current_user = User.find_by_api_token(api_token) || (raise InvalidApiToken.new)

    # authenticate with browser session
    else
      authenticate_user!
    end
  end
end
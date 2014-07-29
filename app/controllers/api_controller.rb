class ApiController < ApplicationController
  before_action :authenticate_user_with_api_token!

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
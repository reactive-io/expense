class ApiController < ApplicationController
  before_action :authenticate_user_with_api_token!
  before_action :authenticate_user!

  private

  def authenticate_user_with_api_token!
    user = User.find_by_api_token(request.headers['X-ApiToken'])

    if user
      sign_in user, store: false
    end
  end
end
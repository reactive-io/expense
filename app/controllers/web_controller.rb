class WebController < ApplicationController
  protect_from_forgery with: :exception

  before_action :authenticate_user!

  layout 'web/layouts/application'

  def index
    @title = 'Expense'

    render file: 'web/layouts/application'
  end
end
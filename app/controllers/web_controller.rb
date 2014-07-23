class WebController < ApplicationController
  layout 'web/layouts/application'

  before_action :authenticate_user!

  def index
    @title = 'Expense'

    render file: 'web/layouts/application'
  end
end
class WebController < ApplicationController
  layout 'web/layouts/application'

  before_action :authenticate_user!

  def index
    render layout: false
  end
end
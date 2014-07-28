class ApplicationController < ActionController::Base
  around_filter :get_time_zone, :if => lambda { request.headers['X-TIME-ZONE'] }

  def get_time_zone(&block)
    Time.use_zone(request.headers['X-TIME-ZONE'], &block)
  end
end

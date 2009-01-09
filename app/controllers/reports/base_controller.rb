class Reports::BaseController < ApplicationController
  before_filter :initialization
  
  def initialization
    params[:start_time] = 3.hours.ago
    params[:end_time] = Time.now
    params[:period] = "minute"
  end
end

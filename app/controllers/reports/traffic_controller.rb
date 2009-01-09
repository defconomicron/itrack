class Reports::TrafficController < ApplicationController
  def index
    @hits = Hit.traffic(params)
  end
  
  def search
    params[:action] = "index"
    redirect_to(params)
  end
end

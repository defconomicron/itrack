class Reports::CountriesController < ApplicationController
  def index
    @hits = Hit.countries(params)
  end
    
  def set_country
    params[:controller] = "regions"
    params[:action] = "index"
    redirect_to(params)
  end
end

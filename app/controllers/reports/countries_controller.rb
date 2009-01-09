class Reports::CountriesController < Reports::BaseController
  def index
    @hits = Hit.countries(params)
  end
    
  def set_country
    params[:controller] = "regions"
    params[:action] = "index"
    redirect_to(params)
  end
end

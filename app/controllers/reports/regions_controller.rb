class Reports::RegionsController < Reports::BaseController
  def index
    @hits = Hit.regions(params)
  end
    
  def set_region
    params[:controller] = "cities"
    params[:action] = "index"
    redirect_to(params)    
  end
end

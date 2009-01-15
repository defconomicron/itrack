class Reports::RegionsController < Reports::BaseController
  def index
    @page_views = PageView.regions(params)
  end
    
  def set_region
    params[:controller] = "cities"
    params[:action] = "index"
    redirect_to(params)    
  end
end

class Reports::CitiesController < Reports::BaseController
  def index
    @page_views = PageView.cities(params)
  end
    
  def set_city
    params[:controller] = "traffic"
    params[:action] = "index"
    redirect_to(params)
  end  
end

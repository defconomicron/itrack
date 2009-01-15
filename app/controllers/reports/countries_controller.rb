class Reports::CountriesController < Reports::BaseController
  def index
    @page_views = PageView.countries(params)
  end
    
  def set_country
    params[:controller] = "regions"
    params[:action] = "index"
    redirect_to(params)
  end
end

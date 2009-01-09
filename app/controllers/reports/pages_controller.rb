class Reports::PagesController < Reports::BaseController  
  def index
    @hits = Hit.pages(params)
  end
  
  def set_page
    params[:controller] = "traffic"
    params[:action] = "index"
    redirect_to(params)
  end
end

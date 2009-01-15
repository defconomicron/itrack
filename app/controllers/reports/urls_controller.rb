class Reports::UrlsController < Reports::BaseController  
  def index
    @page_views = PageView.urls(params)
  end
  
  def set_url
    params[:controller] = "traffic"
    params[:action] = "index"
    redirect_to(params)
  end
end

class Reports::UrlsController < Reports::BaseController  
  def index
    @page_views = PageView.urls(params)
  end
end

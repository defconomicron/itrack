class Reports::RegionsController < Reports::BaseController
  def index
    @page_views = PageView.regions(params)
  end
end

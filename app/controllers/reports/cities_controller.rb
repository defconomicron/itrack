class Reports::CitiesController < Reports::BaseController
  def index
    @page_views = PageView.cities(params)
  end
end

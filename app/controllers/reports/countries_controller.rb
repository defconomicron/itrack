class Reports::CountriesController < Reports::BaseController
  def index
    @page_views = PageView.countries(params)
  end
end

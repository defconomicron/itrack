class Reports::HttpAcceptLanguagesController < Reports::BaseController
  def index
    @page_views = PageView.http_accept_languages(params)
  end
end

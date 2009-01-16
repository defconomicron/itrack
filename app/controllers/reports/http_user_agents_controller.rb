class Reports::HttpUserAgentsController < Reports::BaseController
  def index
    @page_views = PageView.http_user_agents(params)
  end
end

class Reports::TrafficController < Reports::BaseController
  def index
    @page_views = PageView.traffic(params)
    @total_page_views = 0
    @total_visits = 0
    @total_visitors = 0
    @page_views.each do |h|
      @total_page_views += h.page_views.to_i
      @total_visits += h.visits.to_i
      @total_visitors += h.visitors.to_i
    end
  end
  
  def search
    params[:action] = "index"
    redirect_to(params)
  end
end

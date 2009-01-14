class Reports::TrafficController < Reports::BaseController
  def index
    @hits = Hit.traffic(params)
    @total_hits = 0
    @total_visits = 0
    @total_visitors = 0
    @hits.each do |h|
      @total_hits += h.hits.to_i
      @total_visits += h.visits.to_i
      @total_visitors += h.visitors.to_i
    end
  end
  
  def search
    params[:action] = "index"
    redirect_to(params)
  end
end

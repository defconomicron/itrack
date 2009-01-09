class Reports::TrafficController < Reports::BaseController
  def index
    @hits = Hit.traffic(params)
  end
  
  def search
    params[:action] = "index"
    redirect_to(params)
  end
end

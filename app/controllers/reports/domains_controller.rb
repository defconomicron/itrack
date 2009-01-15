class Reports::DomainsController < Reports::BaseController  
  def index
    @page_views = PageView.domains(params)
  end
  
  def set_domain
    params[:controller] = "traffic"
    params[:action] = "index"
    redirect_to(params)
  end
end

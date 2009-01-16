class Reports::DomainsController < Reports::BaseController  
  def index
    @page_views = PageView.domains(params)
  end
end

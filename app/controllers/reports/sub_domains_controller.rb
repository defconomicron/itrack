class Reports::SubDomainsController < Reports::BaseController  
  def index
    @page_views = PageView.sub_domains(params)
  end
end

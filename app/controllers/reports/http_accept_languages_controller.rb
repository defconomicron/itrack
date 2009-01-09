class Reports::HttpAcceptLanguagesController < Reports::BaseController
  def index
    @hits = Hit.http_accept_languages(params)
  end
  
  def set_http_accept_language
    params[:controller] = "traffic"
    params[:action] = "index"
    redirect_to(params)
  end
end

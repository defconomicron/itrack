class Reports::BaseController < ApplicationController
  before_filter :initialization, :only => %w{index}
  
  def search
    params[:action] = "index"
    redirect_to(params)
  end
  
  private
  
    def initialization
      params[:show_page_views] ||= "1"
      params[:show_new_visitors] ||= "1"
      params[:show_return_visitors] ||= "1"
      params[:show_visits] ||= "1"
      if session[:controller] != params[:controller]
        params[:page] = 1
        params[:order] = "page_views desc"
        session[:controller] = params[:controller]
      end
      params.delete(:domain) if params[:domain].blank?
      params[:order] ||= "page_views desc"
      params[:time_span] ||= "Last 3 hours"
      eval(params[:time_span].downcase.split(" ").join("_"))
      @domain_list = PageView.domain_list(params)      
    end
    
    def last_1_hour
      params[:start_time] = 1.hour.ago
      params[:end_time] = Time.now
      params[:labelStep] = 1
      params[:period] = "minute"
      params[:strftime] = "%Y-%m-%d %H:%M:00"
    end
    
    def last_2_hours
      params[:start_time] = 2.hours.ago
      params[:end_time] = Time.now
      params[:labelStep] = 2
      params[:period] = "minute"
      params[:strftime] = "%Y-%m-%d %H:%M:00"
    end
    
    def last_3_hours
      params[:start_time] = 3.hours.ago
      params[:end_time] = Time.now
      params[:labelStep] = 3
      params[:period] = "minute"
      params[:strftime] = "%Y-%m-%d %H:%M:00"
    end
  
    def last_8_hours
      params[:start_time] = 8.hours.ago
      params[:end_time] = Time.now
      params[:labelStep] = 8
      params[:period] = "minute"
      params[:strftime] = "%Y-%m-%d %H:%M:00"
    end
    
    def last_24_hours
      params[:start_time] = 24.hours.ago
      params[:end_time] = Time.now
      params[:labelStep] = 1
      params[:period] = "hour"
      params[:strftime] = "%Y-%m-%d %H:00:00"
    end
    
    def last_2_days
      params[:start_time] = 2.days.ago
      params[:end_time] = Time.now
      params[:labelStep] = 1
      params[:period] = "hour"
      params[:strftime] = "%Y-%m-%d %H:00:00"
    end
    
    def last_3_days
      params[:start_time] = 3.days.ago
      params[:end_time] = Time.now
      params[:labelStep] = 1
      params[:period] = "hour"
      params[:strftime] = "%Y-%m-%d %H:00:00"
    end
    
    def last_7_days
      params[:start_time] = 7.days.ago
      params[:end_time] = Time.now
      params[:labelStep] = 2
      params[:period] = "hour"
      params[:strftime] = "%Y-%m-%d %H:00:00"
    end
end

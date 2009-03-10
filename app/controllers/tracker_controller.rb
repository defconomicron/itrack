class TrackerController < ApplicationController
  def index
    geo_ip = GeoIp.new(ip_address)
    
    PageView.create(
                      {
                        :domain               => domain,
                        :sub_domain           => sub_domain,
                        :url                  => url,
                        :ip_address           => ip_address,
                        :new_visitor          => is_new_visitor?,
                        :return_visitor       => is_return_visitor?,
                        :new_visit            => is_new_visit?,
                        :cookie_id            => cookie_id,
                        :country              => geo_ip.country,
                        :region               => geo_ip.region,
                        :city                 => geo_ip.city,
                        :longitude            => geo_ip.longitude,
                        :latitude             => geo_ip.latitude,
                        :http_user_agent      => http_user_agent,
                        :http_accept_language => http_accept_language
                      }
                   )
    
    new_visitor
    new_visit    
    
    render :file => "#{RAILS_ROOT}/public/images/spacer.gif"
  end
  
  private
  
    def sub_domain
      request.referer.split("/")[2] if request.referer
    end
  
    def domain
      request.referer.split("/")[2].split(".")[-2..-1].join(".") if request.referer      
    end
    
    def url
      request.referer
    end
    
    def ip_address
      request.remote_ip
    end
    
    def is_new_visitor?
      return true if cookies[unique("visitor")].blank?
    end
        
    def is_new_visit?
      return true if cookies[unique("visit")].blank?
    end
    
    def is_return_visitor?
      return true if !is_new_visitor? && is_new_visit?
    end
    
    def new_visitor
      cookies[unique("visitor")] ||= {:value => "1", :expires => 10.years.from_now}
    end
    
    def new_visit
      cookies[unique("visit")] ||= {:value => "1", :expires => 1.hour.from_now}
    end
    
    def cookie_id
      cookies[unique("id")] ||= {:value => rand(10000000000000000000000000000000000000).to_s, :expires => 10.years.from_now}
    end
    
    def unique(t)
      ([t, domain, url] * "").sha1
    end
    
    def http_accept_language
      request.env["HTTP_ACCEPT_LANGUAGE"]
    end
    
    def http_user_agent
      request.env["HTTP_USER_AGENT"]
    end
end

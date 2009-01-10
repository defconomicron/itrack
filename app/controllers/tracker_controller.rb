class TrackerController < ApplicationController
  def index
    geo_ip = GeoIp.new(ip_address)
    
    Hit.create(
                {
                  :domain               => domain,
                  :page                 => page,
                  :ip_address           => ip_address,
                  :new_visitor          => new_visitor?,
                  :new_visit            => new_visit?,
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
    
    create_visitor if new_visitor?
    create_visit if new_visit?    
    
    render :file => "#{RAILS_ROOT}/public/images/spacer.gif"
  end
  
  private
  
    def domain
      referer.split("/")[2].split(".")[-2..-1].join(".") if referer
    end
    
    def page
      referer
    end
    
    def ip_address
      request.env["HTTP_X_FORWARDED_FOR"] ||
      request.env["REMOTE_HOST"] ||
      request.env["REMOTE_ADDR"] ||
      "0.0.0.0"
    end
    
    def new_visitor?
      return true if cookies[:visitor].blank?
    end
    
    def new_visit?
      return true if cookies[:visit].blank?
    end
    
    def create_visitor
      cookies[unique("visitor")] = {:value => "1", :expires => 10.years.from_now}
    end
    
    def create_visit
      cookies[unique("visit")] = {:value => "1", :expires => 1.hour.from_now}
    end
    
    def cookie_id
      cookies[unique("id")] ||= {:value => rand(10000000000000000000000000000000000000).to_s, :expires => 10.years.from_now}
    end
    
    def unique(t)
      t + "_" + ([domain, page] * "").sha1
    end
    
    def referer
      request.env["HTTP_REFERER"]
    end
    
    def http_accept_language
      request.env["HTTP_ACCEPT_LANGUAGE"]
    end
    
    def http_user_agent
      request.env["HTTP_USER_AGENT"]
    end
end

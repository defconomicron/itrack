class GeoIp
  attr_reader :location
  
  def initialize(ip_address)
    @location = GEO_IP.city(ip_address) #www.maxmind.com
  end

  def country
    location[2]
  end
  
  def region
    location[6]
  end
  
  def city
    location[7]
  end
  
  def longitude
    location[9]
  end
  
  def latitude
    location[10]
  end
end

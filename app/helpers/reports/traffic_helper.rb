module Reports::TrafficHelper
  def format_datetime(s)
    return s.to_time.strftime("%m-%d-%Y %I %p") if s.to_time.hour == 0
    s.to_time.strftime("%I %p")
  end
end

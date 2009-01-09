module Reports::TrafficHelper
  def format_datetime1(s)
    return s.to_time.strftime("%a %m-%d-%Y %I:%M %p") if s.to_time.min == 0
    s.to_time.strftime("%I:%M %p")
  end

  def format_datetime2(s)
    return s.to_time.strftime("%a %m-%d-%Y %I %p") if s.to_time.hour == 0
    s.to_time.strftime("%I %p")
  end
end

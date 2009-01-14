module Reports::TrafficHelper
  def boolToNum(bVal)
    bVal ? 1 : 0
  end
  
  def renderChartHTML(chartSWF, strURL, strXML, chartId, chartWidth, chartHeight, debugMode)
    strFlashVars = "&chartWidth=#{chartWidth}&chartHeight=#{chartHeight}&debugMode=#{boolToNum(debugMode)}" << (strXML == "" ? "&dataURL=#{strURL}" : "&dataXML=#{strXML}")
		"<embed wmode=\"transparent\" src=\"#{chartSWF}\" FlashVars=\"#{strFlashVars}\" quality=\"high\" width=\"#{chartWidth}\" height=\"#{chartHeight}\" name=\"#{chartId}\" allowScriptAccess=\"always\" type=\"application/x-shockwave-flash\" pluginspage=\"http://www.macromedia.com/go/getflashplayer\" />"    
  end
  
  def format_datetime(s, prev)
    return s.to_time.strftime("%a %I:%M %p") if params[:period] == "minute" && prev && s.to_time.hour != prev.to_time.hour
    return s.to_time.strftime("%I:%M %p")    if params[:period] == "minute" && prev && s.to_time.hour == prev.to_time.hour
    
    return s.to_time.strftime("%a %I %p") if params[:period] == "hour" && prev && s.to_time.day != prev.to_time.day
    return s.to_time.strftime("%I %p")    if params[:period] == "hour" && prev && s.to_time.day == prev.to_time.day
  end
  
  def format_datetime3(s)
    s.to_time.strftime("%a %m-%d-%Y %I:%M:%S %p")
  end
end

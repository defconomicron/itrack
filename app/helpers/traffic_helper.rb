module TrafficHelper  
  def boolToNum(bVal)
    bVal ? 1 : 0
  end
  
  def renderChartHTML(chartSWF, strURL, strXML, chartId, chartWidth, chartHeight, debugMode)
    strFlashVars = "&chartWidth=#{chartWidth}&chartHeight=#{chartHeight}&debugMode=#{boolToNum(debugMode)}" << (strXML == "" ? "&dataURL=#{strURL}" : "&dataXML=#{strXML}")
    "<embed wmode=\"transparent\" src=\"#{chartSWF}\" FlashVars=\"#{strFlashVars}\" quality=\"high\" width=\"#{chartWidth}\" height=\"#{chartHeight}\" name=\"#{chartId}\" allowScriptAccess=\"always\" type=\"application/x-shockwave-flash\" pluginspage=\"http://www.macromedia.com/go/getflashplayer\" />"    
  end
  
  def format_graph_datetime(curr, prev)
    if (prev.nil? || curr.to_time.day != prev.to_time.day)
      hour = curr.to_time.strftime("%I").to_i
      am_pm = curr.to_time.strftime("%p")[0..0]
      return curr.to_time.strftime("%a #{hour}:%M #{am_pm}") if params[:period] == "minute"
      return curr.to_time.strftime("%a #{hour} #{am_pm}") if params[:period] == "hour"
    end
    
    if (prev.nil? || curr.to_time.day == prev.to_time.day)
      hour = curr.to_time.strftime("%I").to_i
      am_pm = curr.to_time.strftime("%p")[0..0]
      return curr.to_time.strftime("#{hour}:%M #{am_pm}") if params[:period] == "minute"
      return curr.to_time.strftime("#{hour} #{am_pm}") if params[:period] == "hour"
    end
  end
  
  def format_datetime(s)
    s.to_time.strftime("%a %m-%d-%Y %I:%M:%S %p")
  end
end

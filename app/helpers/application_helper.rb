# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def boolToNum(bVal)
    bVal ? 1 : 0
  end
  
  def renderChartHTML(chartSWF, strURL, strXML, chartId, chartWidth, chartHeight, debugMode)
    strFlashVars = "&chartWidth=#{chartWidth}&chartHeight=#{chartHeight}&debugMode=#{boolToNum(debugMode)}" << (strXML == "" ? "&dataURL=#{strURL}" : "&dataXML=#{strXML}")
		"<embed wmode=\"transparent\" src=\"#{chartSWF}\" FlashVars=\"#{strFlashVars}\" quality=\"high\" width=\"#{chartWidth}\" height=\"#{chartHeight}\" name=\"#{chartId}\" allowScriptAccess=\"always\" type=\"application/x-shockwave-flash\" pluginspage=\"http://www.macromedia.com/go/getflashplayer\" />"    
  end
  
  def time_spans
    [
      "Last 1 hour",
      "Last 2 hours",
      "Last 3 hours",
      "Last 8 hours",
      "Last 24 hours",
      "Last 2 days",
      "Last 3 days",
      "Last 7 days"
    ]
  end
  
  def sort_control(title, default_order)
    image = ""
    if params[:order] && params[:order].split(" ")[0] == default_order.split(" ")[0]
      column = params[:order].split(" ")[0]
      polarity = params[:order].split(" ")[1] == "asc" ? "desc" : "asc"
      image = (polarity == "asc" ? image_tag("ico_down_arrow.gif", :border => 0) : image_tag("ico_up_arrow.gif", :border => 0))
    else
      column = default_order.split(" ")[0]
      polarity = default_order.split(" ")[1]
    end
    link_to("#{title} #{image}", {:params => params.merge({:order => "#{column} #{polarity}"})})
  end
end

# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def boolToNum(bVal)
    bVal ? 1 : 0
  end
  
  def renderChartHTML(chartSWF, strURL, strXML, chartId, chartWidth, chartHeight, debugMode)
    strFlashVars = "&chartWidth=#{chartWidth}&chartHeight=#{chartHeight}&debugMode=#{boolToNum(debugMode)}" << (strXML == "" ? "&dataURL=#{strURL}" : "&dataXML=#{strXML}")
		"<embed wmode=\"transparent\" src=\"#{chartSWF}\" FlashVars=\"#{strFlashVars}\" quality=\"high\" width=\"#{chartWidth}\" height=\"#{chartHeight}\" name=\"#{chartId}\" allowScriptAccess=\"always\" type=\"application/x-shockwave-flash\" pluginspage=\"http://www.macromedia.com/go/getflashplayer\" />"    
  end
end

module ApplicationHelper
  def title(page_title = "没得比")
    content_for :title, page_title.to_s
  end
  def keywords(page_keywords = "没得比,没的比,没得比官网")
    content_for :keywords, page_keywords.to_s
  end
  def head_desc(page_description = "")
    content_for :head_desc, page_description.to_s
  end
  def mobile_url(path)
    content_for :mobile_url, "http://m.mdebi.com#{path}"
  end
  def path(path)
    content_for :path, path
  end

  def output_strong_mark(text)
    text.gsub(/###(.*?)###/){|item| "<strong>#{item.gsub('###','')}</strong>"}
  end

  def traffic_desc(traffic)
    if traffic < 1024 && traffic > 0
      return "#{traffic}B"
    elsif traffic >= 1024 && traffic < 1024 * 1024
      return "#{traffic / 1024}KB"
    elsif traffic >= 1048576 && traffic < 1073741824
      return "#{traffic / 1048576}MB"
    elsif traffic >= 1073741824 && traffic < 1099511627776
      return "#{(traffic * 1.0 / 1073741824).round(2)}GB"
    elsif traffic <= 0
      return "0"
    else
      return "海量GB"
    end
  end

  def is_turbolinks_cache?(cache = true)
    content_for :turbolinks_cache, cache ? 'cache' : 'no-cache'
  end
end

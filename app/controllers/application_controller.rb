require 'hmac-sha1'
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def is_robot?
    user_agent = request.headers["HTTP_USER_AGENT"]
    user_agent.present? && user_agent =~ /(bot|spider|slurp)/i
  end

  def is_device_mobile?
    user_agent = request.headers["HTTP_USER_AGENT"]
    user_agent.present? && user_agent =~ /\b(Android|iPhone|Windows Phone|Opera Mobi|Kindle|BackBerry|PlayBook|UCWEB|Mobile)\b/i
  end

  def is_ipad?
    request.headers["HTTP_USER_AGENT"] =~ /ipad/i
  end

  def is_inapp?
    request.headers["HTTP_USER_AGENT"] =~ /turbolinks-app, yysssr|wzry|mhxy|qjnn|hszz|lzg|gmdl|jtlq/i
  end

  def app_uuid
    uuid = request.headers["HTTP_USER_AGENT"].match(/uuid ([\d\w\-]{36})/)
    if uuid
      return uuid[1]
    else
      return ""
    end
  end

  def is_app_new?
    request.headers["HTTP_USER_AGENT"] =~ /turbolinks-app, (yysssr|wzry|mhxy|qjnn|hszz), version=(1.6.0|1.3.1|1.1.0|1.0.0)/i
  end
  def not_found
    raise ActionController::RoutingError.new('NOT FOUND')
  end

  def do_ali_search(keyword, app_name, index_name = 'default')
    secret = ''
    hash = {}
    hash["Version"] = "v2"
    hash["AccessKeyId"] = ''
    hash["SignatureMethod"] = "HMAC-SHA1"
    hash["Timestamp"] = Time.now.utc.strftime("%Y-%m-%dT%H:%M:%SZ")
    hash["SignatureVersion"] = "1.0"
    hash["SignatureNonce"] = "#{Time.now.to_i}#{"%04d" % rand(9999)}"
    hash["index_name"] = app_name
    hash["query"] = "query=#{index_name}:'#{keyword}'&&sort=-id&&config=hit:100,format:fulljson"
    hash["query"] = URI.encode(hash["query"]).gsub("'",'%27').gsub(':','%3A').gsub('&','%26').gsub('=','%3D').gsub(',', '%2C')
    hash["Timestamp"] = URI.encode(hash["Timestamp"],"\/=&:\'")
    h = hash.sort{|a,b| a[0] <=> b[0]}
    s = h.map{|item| "#{item[0]}=#{item[1]}"}.join('&')
    signToString = "GET&%2F&" + URI.encode(s,'=%&')
    hmac = HMAC::SHA1.new("#{secret}&")
    hmac.update(signToString)
    sign = Base64.encode64("#{hmac.digest}")
    hash["Signature"] = URI.encode(sign.gsub("\n",''),'%=&\/+')
    ss = hash.map{|item| "#{item[0]}=#{item[1]}"}.join('&')
    url = "http://opensearch-cn-beijing.aliyuncs.com/search?#{ss}"
    JSON.parse(Net::HTTP.get(URI(url)))
  end
end

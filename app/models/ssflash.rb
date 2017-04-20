class FUser < ActiveRecord::Base
  self.table_name = 'flash_users'
end

class FNode < ActiveRecord::Base
  self.table_name = 'flash_nodes'
end

class FTrafficLog < ActiveRecord::Base
  self.table_name = 'flash_traffic_logs'
end

class FProduct < ActiveRecord::Base
  self.table_name = 'flash_traffic_products'
end
class FActivePort < ActiveRecord::Base
  self.table_name = 'flash_active_ports'
end
class FPortUser < ActiveRecord::Base
  self.table_name = 'flash_port_user_relations'
end

class FIpnMessage < ActiveRecord::Base
  self.table_name = 'flash_ipn_messages'
  def is_verified?
    url_product = "https://www.paypal.com/cgi-bin/webscr"
    url_sandbox = "https://www.sandbox.paypal.com/cgi-bin/webscr"
    params = {}
    params['cmd'] = '_notify-validate'
    self.original_post_params.split("&").each do |pa|
      sp = pa.split('=')
      params[sp[0]] = sp[1]
    end
    if params['test_ipn'] && params['test_ipn'] == '1'
      url = url_sandbox
    else
      url = url_product
    end
    uri = URI(url)
    req = Net::HTTP::Post.new(uri)
    req.body = URI.encode_www_form(params)
    req.content_type = 'text/html; charset=utf-8'
    res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https') do |http|
        http.request(req)
    end
    res.body == 'VERIFIED'
  end
end

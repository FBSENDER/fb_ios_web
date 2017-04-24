Rails.application.routes.draw do
  root "home#index"
  #app
  get "/yys/card/:id", to: "yys#card"
  get "/yys/card_ssr", to: "yys#card_ssr"
  get "/yys/card_sr", to: "yys#card_sr"
  get "/yys/card_r", to: "yys#card_r"
  get "/yys/yuhun/:id", to: "yys#yuhun"
  get "/yys/collect/:ids", to: "yys#collect"
  get "/yys/ad_google", to: "yys#ad_google"
  get "/yys/article_gonglve", to: "yys#article_gonglve"
  get "/yys/article_news", to: "yys#article_news"
  get "/yys/article_wenda", to: "yys#article_wenda"
  get "/yys/article_shipin", to: "yys#article_shipin"
  get "/yys/article/:id", to: "yys#article", id: /\d+/
  get "/yys/tag/:name", to: "yys#tag"
  get "/yys/ali_search/:keyword", to: "yys#ali_search"
  get "/yys/jubao", to: "yys#jubao"
  get "/yys/hot", to: "yys#hot"
  get "/yys/download", to: "app#download"
  get "/yys/config_info", to: "app#config_info"

  #gmdl
  get "/gmdl/article/:id", to: "gmdl#article", id: /\d+/
  get "/gmdl/source/:id", to: "gmdl#source"
  get "/gmdl/article_list/:category_id", to: "gmdl#article_list", category_id: /\d+/
  get "/gmdl/tag/:name", to: "gmdl#tag"
  get "/gmdl/zhiye/", to: "gmdl#zhiye"
  get "/gmdl/collect/:ids", to: "gmdl#collect"
  get "/gmdl/hot", to: "gmdl#hot"
  get "/gmdl/search/:keyword", to: "gmdl#search"

  #flash
  get '/ssnode/users/' => 'flash#users'
  post '/ssnode/traffic_cost' => 'flash#traffic_cost'

  get "/flash/:uuid", to: "flash#user_home", uuid: /[\d\w\-]{36}/
  get "/flash/:uuid/user_cstring", to: "flash#user_cstring", uuid: /[\d\w\-]{36}/
  get "/flash/:uuid/check_in", to: "flash#user_check_in", uuid: /[\d\w\-]{36}/
  get "/flash/:uuid/purchase", to: "flash#purchase", uuid: /[\d\w\-]{36}/
  get "/flash/:uuid/purchase_in_app", to: "flash#purchase_in_app", uuid: /[\d\w\-]{36}/
  get "/flash/:uuid/purchase_in_app_log", to: "flash#purchase_in_app_log", uuid: /[\d\w\-]{36}/
  get "/flash/:uuid/traffic_log", to: "flash#traffic_log", uuid: /[\d\w\-]{36}/
  post "/flash/ipn_notify", to: "flash#ipn_notify"
  post "/flash/:uuid/pia_notify", to: "flash#pia_notify"
end

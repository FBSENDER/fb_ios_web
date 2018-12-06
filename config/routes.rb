Rails.application.routes.draw do
  root "home#index"
  #app
  get "/yys/card/:id", to: "yys#card"
  get "/yys/card_sp", to: "yys#card_sp"
  get "/yys/card_ssr", to: "yys#card_ssr"
  get "/yys/card_sr", to: "yys#card_sr"
  get "/yys/card_r", to: "yys#card_r"
  get "/yys/yuhun/:id", to: "yys#yuhun"
  get "/yys/collect/:ids", to: "yys#collect"
  get "/yys/ad_google", to: "yys#ad_google"
  get "/app/ad_google", to: "yys#ad_google"
  get "/yys/article_gonglve", to: "yys#article_gonglve"
  get "/yys/article_news", to: "yys#article_news"
  get "/yys/article_wenda", to: "yys#article_wenda"
  get "/yys/article_shipin", to: "yys#article_shipin"
  get "/yys/article/:id", to: "yys#article", id: /\d+/
  get "/yys/tag/:name", to: "yys#tag"
  get "/yys/ali_search/:keyword", to: "yys#ali_search"
  get "/yys/jubao", to: "yys#jubao"
  get "/yys/hot", to: "yys#hot"
  get "/yys/download", to: "yys#download"
  get "/yys/config_info", to: "yys#config_info"

  #mrzh
  get "/mrzh/collect/:ids", to: "mrzh#collect"
  get "/mrzh/article_gonglve", to: "mrzh#article_gonglve"
  get "/mrzh/article_news", to: "mrzh#article_news"
  get "/mrzh/article_wenda", to: "mrzh#article_wenda"
  get "/mrzh/article/:id", to: "mrzh#article", id: /\d+/
  get "/mrzh/tag/:name", to: "mrzh#tag"
  get "/mrzh/ali_search/:keyword", to: "mrzh#ali_search"
  get "/mrzh/hot", to: "mrzh#hot"

  #hyxd
  get "/hyxd/article_gonglve", to: "hyxd#article_gonglve"
  get "/hyxd/article_news", to: "hyxd#article_news"
  get "/hyxd/article_wenda", to: "hyxd#article_wenda"
  get "/hyxd/article_shipin", to: "hyxd#article_shipin"
  get "/hyxd/article/:id", to: "hyxd#article", id: /\d+/
  get "/hyxd/tag/:name", to: "hyxd#tag"
  get "/hyxd/eqp/:id", to: "hyxd#eqp_list"
  get "/hyxd/gun_list", to: "hyxd#gun_list"
  get "/hyxd/gun/:id", to: "hyxd#gun", id: /\d+/
  get "/hyxd/collect/:ids", to: "hyxd#collect"

  #gmdl
  get "/gmdl/article/:id", to: "gmdl#article", id: /\d+/
  get "/gmdl/source/:id", to: "gmdl#source"
  get "/gmdl/article_list/:category_id", to: "gmdl#article_list", category_id: /\d+/
  get "/gmdl/tag/:name", to: "gmdl#tag"
  get "/gmdl/zhiye/", to: "gmdl#zhiye"
  get "/gmdl/collect/:ids", to: "gmdl#collect"
  get "/gmdl/hot", to: "gmdl#hot"
  get "/gmdl/search/:keyword", to: "gmdl#search"

  #wzry
  get "/wzry/article/:id", to: "wzry#article", id: /\d+/
  get "/wzry/source/:id", to: "wzry#source", id: /\d+/
  get "/wzry/article_list/:category_id", to: "wzry#article_list", category_id: /\d+/
  get "/wzry/tag/:name", to: "wzry#tag"
  get "/wzry/hero_list", to: "wzry#hero_list"
  get "/wzry/ali_search/:keyword", to: "wzry#ali_search"
  get "/wzry/hot", to: "wzry#hot"
  get "/wzry/collect/:ids", to: "wzry#collect"
  get "/wzry/qq_video/", to: "wzry#qq_video_list"
  get "/wzry/qq_video/:id", to: "wzry#qq_video_detail"
  get "/wzry/qq_video_collect/:ids", to: "wzry#qq_video_collect"
  get "/wzry/qq_video_search/:keyword", to: "wzry#qq_video_search"
  get "/wzry/zhibo/huya/:id", to: "wzry#huya_detail"
  get "/wzry/zhibo/huya_list/:id", to: "wzry#huya_list"

  get "/wzry/hero/:id.html", to: "wzry#hero_source", id: /\d+/
  get "/wzrydb/hero_list", to: "wzry#db_hero_list"
  get "/wzrydb/hero/:id", to: "wzry#db_hero"
  get "/wzrydb/equip_list", to: "wzry#db_equip_list"
  get "/wzrydb/equip/:id", to: "wzry#db_equip"
  get "/wzrydb/rune_list", to: "wzry#db_rune_list"

  #common
  get "/common/changyan", to: "common#changyan"

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
  get "/flash/is_in_china", to: "flash#is_in_china"

  #pic
  get "/pic/home", to: "pic#home"
  get "/pic/brand", to: "pic#brand"
  get "/pic/brand_topics/:id", to: "pic#brand_topics"
end

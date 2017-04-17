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

end

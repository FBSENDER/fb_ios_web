require 'yys'
class YysController < ApplicationController
  @@hot_topics = []

  def ali_search
    tag = ArticleTag.where(name: params[:keyword]).take
    if tag
      redirect_to "/yys/tag/#{URI.encode(tag.name)}/"
      return 
    end
    @keyword = params[:keyword].strip
    @articles = Article.where("title like ? and status = 1", "%#{@keyword}%").select(:id,:title,:tags,:img_url,:description,:category_id,:source_id).order("source_id desc").paginate(page: params[:page])
    if @articles.nil? || @articles.size.zero? && params[:page].nil?
      redirect_to "#{URI.encode("/yys/hot?message=没有找到...")}"
      return
    end
    @path = request.fullpath
    @is_ipad = is_ipad?
    if request.xhr?
      render partial: "article_list", locals: {articles: @articles}
      return 
    end
    render "article_list"

  end
  def ali_search_old
    tag = ArticleTag.where(name: params[:keyword]).take
    if tag
      redirect_to "/yys/tag/#{URI.encode(tag.name)}/"
      return 
    end

    data = do_ali_search(params[:keyword], "yysssr_app")
    if data["status"] != 'OK'
      redirect_to "#{URI.encode("/yys/hot?message=没有找到...")}"
      return
    end
    items = data["result"]["items"]
    if items.size.zero?
      redirect_to "#{URI.encode("/yys/hot?message=没有找到...")}"
      return
    end
    @articles = []
    items.each do |item|
      article = Article.new
      article.id = item["fields"]["id"]
      article.title = item["fields"]["title"]
      article.tags = item["fields"]["tags"]
      article.img_url = item["fields"]["img_url"]
      article.description = item["fields"]["description"]
      article.category_id = item["fields"]["category_id"]
      @articles << article
    end
    @path = request.fullpath
    @is_ipad = is_ipad?
    @no_paginate = true
    render "yys/article_list"
  end

  def collect
    @articles = Article.where(status:1, id: params[:ids].split(',').map{|id| id.to_i}).select(:id,:title,:tags,:img_url,:description,:category_id,:source_id).order("source_id desc").paginate(page: params[:page])
    @path = request.fullpath
    @is_ipad = is_ipad?
    if request.xhr?
      render partial: "article_list", locals: {articles: @articles}
      return 
    end
    render "article_list"
  end

  def tag
    @tag = ArticleTag.where(name: params[:name]).take
    not_found if @tag.nil?
    @card = Card.where(name: @tag.name).select(:id,:name,:img_url).take
    @yuhun = Yuhun.where(name: @tag.name).select(:img_url,:name,:xiaoguo_1,:xiaoguo_2,:tuijian,:diaoluo,:type_1,:type_2).take
    @articles = Article.where(status:1, id: @tag.relation_id.split(',')).select(:id,:title,:tags,:img_url,:description,:category_id,:source_id).order("source_id desc").paginate(page: params[:page])
    @path = request.fullpath
    @is_ipad = is_ipad?
    if request.xhr?
      render partial: "article_list", locals: {articles: @articles}
      return 
    end
    render "article_list"
  end
  def article
    @article = Article.where(id: params[:id].to_i).take
    not_found if @article.nil?
    @contents = JSON.parse(@article.article_content)
    @path = request.fullpath
    @next = Article.where("id > ? and category_id = ? and status = 1", @article.id, @article.category_id).order("id").take
    @pre = Article.where("id < ? and category_id = ? and status = 1", @article.id, @article.category_id).order("id desc").take
    #@show_pinglun_ad = is_app_new? && @article.id == 1827
    @show_pinglun_ad = false
  end
  def article_gonglve
    @articles = Article.where(category_id: 1, status: 1).select(:id,:title,:tags,:img_url,:description,:category_id,:source_id).order("source_id desc").paginate(page: params[:page])
    @path = request.fullpath
    @is_ipad = is_ipad?
    if request.xhr?
      render partial: "article_list", locals: {articles: @articles}
      return 
    end
    render "article_list"
  end
  def article_news
    @articles = Article.where(category_id: 2, status: 1).select(:id,:title,:tags,:img_url,:description,:category_id,:source_id).order("source_id desc").paginate(page: params[:page])
    @path = request.fullpath
    @is_ipad = is_ipad?
    if request.xhr?
      render partial: "article_list", locals: {articles: @articles}
      return 
    end
    render "article_list"
  end
  def article_wenda
    @articles = Article.where(category_id: 3, status: 1).select(:id,:title,:tags,:img_url,:description,:category_id,:source_id).order("source_id desc").paginate(page: params[:page])
    @path = request.fullpath
    @is_ipad = is_ipad?
    if request.xhr?
      render partial: "article_list", locals: {articles: @articles}
      return 
    end
    render "article_list"
  end
  def article_shipin
    @articles = Article.where(category_id: 4, status: 1).select(:id,:title,:tags,:img_url,:description,:category_id,:source_id).order("source_id desc").paginate(page: params[:page])
    @path = request.fullpath
    @is_ipad = is_ipad?
    if request.xhr?
      render partial: "article_list", locals: {articles: @articles}
      return 
    end
    render "article_list"
  end
  def card_sp
    @cards = Card.where(level: 'sp').select(:id,:img_url,:name).order("id desc")
    render "card_list"
  end
  def card_ssr
    @cards = Card.where(level: 'ssr').select(:id,:img_url,:name).order("id desc")
    render "card_list"
  end
  def card_sr
    @cards = Card.where(level: 'sr').select(:id,:img_url,:name).order("id desc")
    render "card_list"
  end
  def card_r
    @cards = Card.where(level: 'r').select(:id,:img_url,:name).order("id desc")
    render "card_list"
  end
  def card
    @card = Card.where(id: params[:id].to_i).take
    not_found if @card.nil?
    @juexing = JSON.parse(@card.juexing_json)
    @skill = JSON.parse(@card.skill_json)
    @team = JSON.parse(@card.team_json)
    @suit = JSON.parse(@card.suit_json)
    @path = request.fullpath
    @next = Card.where("id > ?", @card.id).order("id").take
    @pre = Card.where("id < ?", @card.id).order("id desc").take
    @show_pinglun_ad = is_app_new? && [90,89,87].include?(@card.id)
    #@show_pinglun_ad = false
  end
  def yuhun
    @yuhuns = params[:id].to_i > 0 ? Yuhun.where(type_id: params[:id].to_i).select(:name, :img_url,:type_1, :type_2, :xiaoguo_1).order("type_1") : Yuhun.select(:name, :img_url,:type_1, :type_2, :xiaoguo_1).order("type_1")
    @title = "御魂图鉴"
    render "yuhun_list"
  end
  def hot
    @path = request.fullpath
    @tags = ArticleTag.pluck(:name).sample(25)
  end
  def jubao
  end

  def download
    redirect_to "http://www.baidu.com"
  end

  def config_info
    render json: {"tag_view_controllers":[{"title":"图鉴","path":"/yys/card_ssr/","image_name":"favorites","tag":0,"header_items":["SSR","SP","SR","R","御魂"],"header_paths":["/yys/card_ssr/","/yys/card_sp/","/yys/card_sr/","/yys/card_r/","/yys/yuhun/0/"],"add_search_button":true,"search_path":"/yys/hot/"},{"title":"攻略","path":"/yys/article_gonglve/","image_name":"topic","add_search_button":true,"search_path":"/yys/hot/","header_items":["攻略","资讯","问答","视频"],"header_paths":["/yys/article_gonglve/","/yys/article_news/","/yys/article_wenda/","/yys/article_shipin/"]}],"routes":[{"title":"SSR式神","path":"/yys/card_ssr","add_share_button":false},{"title":"SP式神","path":"/yys/card_sp","add_share_button":false},{"title":"SR式神","path":"/yys/card_sr","add_share_button":false},{"title":"R式神","path":"/yys/card_r","add_share_button":false},{"title":"御魂图鉴","path":"/yys/yuhun/:id","add_share_button":false},{"title":"热门标签","path":"/yys/tag/:name","add_share_button":true},{"title":"搜索攻略","path":"/yys/hot","add_share_button":false,"show_google_ad":true},{"title":"用户反馈","path":"/yys/jubao","add_share_button":false},{"title":"攻略秘籍","path":"/yys/article_gonglve","add_share_button":false},{"title":"新闻资讯","path":"/yys/article_news","add_share_button":false},{"title":"新手问答","path":"/yys/article_wenda","add_share_button":false},{"title":"视频攻略","path":"/yys/article_shipin","add_share_button":false},{"title":"式神图鉴","path":"/yys/card/:id","add_share_button":true,"show_google_ad":true},{"title":"阅读攻略","path":"/yys/article/:id","add_share_button":true,"show_google_ad":true},{"title":"我的收藏","path":"/yys/collect/:name","add_share_button":false}]}
  end

  def ad_google
  end
end

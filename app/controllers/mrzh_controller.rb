require 'mrzh'
class MrzhController < ApplicationController
  @@hot_topics = []

  def ali_search
    tag = MrzhArticleTag.where(name: params[:keyword]).take
    if tag
      redirect_to "/mrzh/tag/#{URI.encode(tag.name)}/"
      return 
    end
    @keyword = params[:keyword].strip
    @articles = MrzhArticle.where("title like ? and status = 1", "%#{@keyword}%").select(:id,:title,:tags,:img_url,:description,:category_id,:source_id).order("source_id desc").paginate(page: params[:page])
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

  def collect
    @articles = MrzhArticle.where(status:1, id: params[:ids].split(',').map{|id| id.to_i}).select(:id,:title,:tags,:img_url,:description,:category_id,:source_id).order("source_id desc").paginate(page: params[:page])
    @path = request.fullpath
    @is_ipad = is_ipad?
    if request.xhr?
      render partial: "article_list", locals: {articles: @articles}
      return 
    end
    render "article_list"
  end

  def tag
    @tag = MrzhArticleTag.where(name: params[:name]).take
    not_found if @tag.nil?
    @articles = MrzhArticle.where(status:1, id: @tag.relation_id.split(',')).select(:id,:title,:tags,:img_url,:description,:category_id,:source_id).order("source_id desc").paginate(page: params[:page])
    @path = request.fullpath
    @is_ipad = is_ipad?
    if request.xhr?
      render partial: "article_list", locals: {articles: @articles}
      return 
    end
    render "article_list"
  end
  def article
    @article = MrzhArticle.where(id: params[:id].to_i).take
    not_found if @article.nil?
    @contents = JSON.parse(@article.article_content)
    @path = request.fullpath
    @next = MrzhArticle.where("id > ? and category_id = ? and status = 1", @article.id, @article.category_id).order("id").take
    @pre = MrzhArticle.where("id < ? and category_id = ? and status = 1", @article.id, @article.category_id).order("id desc").take
    #@show_pinglun_ad = is_app_new? && @article.id == 1827
    @show_pinglun_ad = false
  end
  def article_gonglve
    @articles = MrzhArticle.where(category_id: 1, status: 1).select(:id,:title,:tags,:img_url,:description,:category_id,:source_id).order("source_id desc").paginate(page: params[:page])
    @path = request.fullpath
    @is_ipad = is_ipad?
    if request.xhr?
      render partial: "article_list", locals: {articles: @articles}
      return 
    end
    render "article_list"
  end
  def article_news
    @articles = MrzhArticle.where(category_id: 2, status: 1).select(:id,:title,:tags,:img_url,:description,:category_id,:source_id).order("source_id desc").paginate(page: params[:page])
    @path = request.fullpath
    @is_ipad = is_ipad?
    if request.xhr?
      render partial: "article_list", locals: {articles: @articles}
      return 
    end
    render "article_list"
  end
  def article_wenda
    @articles = MrzhArticle.where(category_id: 3, status: 1).select(:id,:title,:tags,:img_url,:description,:category_id,:source_id).order("source_id desc").paginate(page: params[:page])
    @path = request.fullpath
    @is_ipad = is_ipad?
    if request.xhr?
      render partial: "article_list", locals: {articles: @articles}
      return 
    end
    render "article_list"
  end
  def hot
    @path = request.fullpath
    @tags = MrzhArticleTag.pluck(:name).sample(25)
  end

end

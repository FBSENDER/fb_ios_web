require 'gmdl'
class GmdlController < ApplicationController
  def tag
    @tag = GmdlArticleTag.where(name: params[:name]).take
    not_found if @tag.nil?
    @articles = GmdlArticle.where(status:1, id: @tag.relation_id.split(',')).select(:id,:title,:tags,:img_url,:description,:category_id).order("id desc").paginate(page: params[:page])
    @path = request.fullpath
    @is_ipad = is_ipad?
    if request.xhr?
      render partial: "article_list", locals: {articles: @articles}
      return 
    end
    render "article_list"
  end

  def article
    @article = GmdlArticle.where(id: params[:id].to_i).take
    not_found if @article.nil?
    @contents = JSON.parse(@article.article_content)
    @path = request.fullpath
    @next = GmdlArticle.where("id > ? and category_id = ? and status = 1", @article.id, @article.category_id).order("id").take
    @pre = GmdlArticle.where("id < ? and category_id = ? and status = 1", @article.id, @article.category_id).order("id desc").take
    @show_pinglun_ad = @article.id == 381
  end
  def source
    article = GmdlArticle.where(source_id: params[:id]).take
    not_found if article.nil?
    redirect_to "/gmdl/article/#{article.id}/"
  end
  def article_list
    @category_id = params[:category_id] || 1
    @articles = GmdlArticle.where(category_id: @category_id.to_i, status: 1).select(:id,:title,:tags,:img_url,:description,:category_id).order("id desc").paginate(page: params[:page])
    @path = request.fullpath
    @is_ipad = is_ipad?
    @title = "攻略列表"
    if request.xhr?
      render partial: "article_list", locals: {articles: @articles}
      return 
    end
    render "article_list"
  end

  def zhiye
    @zhiyes = GmdlZhiye.all.to_a
    @title = "职业介绍"
  end

  def collect
    @articles = GmdlArticle.where(status:1, id: params[:ids].split(',').map{|id| id.to_i}).select(:id,:title,:tags,:img_url,:description,:category_id).order("id desc").paginate(page: params[:page])
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
    @tags = GmdlArticleTag.where("relation_id <> ''").pluck(:name).sample(25)
  end

  def search
    @articles = GmdlArticle.where("title like ? and status = 1", "%#{params[:keyword]}%").select(:id,:title,:tags,:img_url,:description,:category_id).order("id desc").paginate(page: params[:page])
    @path = request.fullpath
    @is_ipad = is_ipad?
    @title = "攻略搜索"
    if request.xhr?
      render partial: "article_list", locals: {articles: @articles}
      return 
    end
    render "article_list"
  end

end

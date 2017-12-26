require 'hyxd'
class HyxdController < ApplicationController
  def article
    @article = HyxdArticle.where(id: params[:id].to_i).take
    not_found if @article.nil?
    @contents = JSON.parse(@article.article_content)
    @path = request.fullpath
    @next = HyxdArticle.where("id > ? and category_id = ? and status = 1", @article.id, @article.category_id).order("id").take
    @pre = HyxdArticle.where("id < ? and category_id = ? and status = 1", @article.id, @article.category_id).order("id desc").take
  end

  def article_news
    article_list(1)
  end

  def article_gonglve
    article_list(2)
  end

  def article_wenda
    article_list(3)
  end

  def article_shipin
    article_list(4)
  end

  def article_list(id)
    @articles = HyxdArticle.where(category_id: id, status: 1).select(:id,:title,:tags,:img_url,:description,:category_id).order("source_id desc").paginate(page: params[:page])
    @path = request.fullpath
    @is_ipad = is_ipad?
    if request.xhr?
      render partial: "article_list", locals: {articles: @articles}
      return 
    end
    render "article_list"
  end

  def eqp_list
    @eqps = case params[:id].to_i
            when 0 then HyxdEqp.all.to_a
            when 1 then HyxdEqp.where(eqp_type: "载具").to_a
            when 2 then HyxdEqp.where(eqp_type: "瞄具").to_a
            when 3 then HyxdEqp.where(eqp_type: "药品").to_a
            when 4 then HyxdEqp.where(eqp_type: "配件").to_a
            when 5 then HyxdEqp.where(eqp_type: "防具").to_a
            end
    render "eqp_list"
  end

  def gun_list
    @guns = HyxdGun.all.to_a
  end

  def gun
    @gun = HyxdGun.where(id: params[:id].to_i).take
    not_found if @gun.nil?
  end

  def tag
    @tag = HyxdArticleTag.where(name: params[:name]).take
    not_found if @tag.nil?
    @articles = HyxdArticle.where(status:1, id: @tag.relation_id.split(',')).select(:id,:title,:tags,:img_url,:description,:category_id).order("id desc").paginate(page: params[:page])
    @path = request.fullpath
    @is_ipad = is_ipad?
    if request.xhr?
      render partial: "article_list", locals: {articles: @articles}
      return 
    end
    render "article_list"
  end

  def collect
    @articles = HyxdArticle.where(status:1, id: params[:ids].split(',').map{|id| id.to_i}).select(:id,:title,:tags,:img_url,:description,:category_id).order("id desc").paginate(page: params[:page])
    @path = request.fullpath
    @is_ipad = is_ipad?
    if request.xhr?
      render partial: "article_list", locals: {articles: @articles}
      return 
    end
    render "article_list"
  end

end

require 'gongzhu'
class YuanzhengController < ApplicationController
  def cards
    cards = YCard.select(:id, :name, :avatar, :zhenying, :article_id).to_a
    zhenyings = cards.map{|c| c.zhenying}.uniq
    render json: {cards: cards, zs: zhenyings}
  end

  def fubens
    fubens = YFuben.select(:id, :name, :pic_url, :fenlei, :article_id).to_a
    zs = fubens.map{|f| f.fenlei}.uniq
    render json: {fubens: fubens, zs: zs}
  end

  def article
    @article = YArticle.where(id: params[:id].to_i).take
    if @article.nil?
      render json: {status: 0}
      return
    end
    @next = YArticle.where("id > ? and category_id = ?", @article.id, @article.category_id).order("id").select(:id, :title).take
    @pre = YArticle.where("id < ? and category_id = ?", @article.id, @article.category_id).order("id desc").select(:id, :title).take
    render json: {status: 1, title: @article.title, tags: @article.tags.split(','), category_id: @article.category_id, content: JSON.parse(@article.article_content), next: @next, pre: @pre}
  end

  def article_list
    @articles = YArticle.where(category_id: params[:category_id].to_i).select(:id,:title,:tags,:img_url,:description,:category_id,:source_id).order("source_id desc").paginate(page: params[:page])
    render json: {status: 1, data: @articles}
  end

  def search
    @keyword = params[:keyword].strip
    @articles = YArticle.where("title like ?", "%#{@keyword}%").select(:id,:title,:tags,:img_url,:description,:category_id,:source_id).order("source_id desc").paginate(page: params[:page])
    if @articles.nil? || @articles.size.zero? && params[:page].nil?
      render json: {status: 0}
      return
    end
    render json: {status: 1, data: @articles}
  end

end

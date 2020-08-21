require 'gongzhu'
class FangzhouController < ApplicationController

  def article
    @article = FArticle.where(id: params[:id].to_i).take
    if @article.nil?
      render json: {status: 0}
      return
    end
    @next = FArticle.where("id > ? and category_id = ? and status = 1", @article.id, @article.category_id).order("id").select(:id, :title).take
    @pre = FArticle.where("id < ? and category_id = ? and status = 1", @article.id, @article.category_id).order("id desc").select(:id, :title).take
    render json: {status: 1, title: @article.title, tags: @article.tags.split(','), category_id: @article.category_id, content: JSON.parse(@article.article_content), next: @next, pre: @pre}
  end

  def article_list
    @articles = FArticle.where(category_id: params[:category_id].to_i).select(:id,:title,:tags,:img_url,:description,:category_id,:source_id).order("source_id desc").paginate(page: params[:page])
    render json: {status: 1, data: @articles}
  end

  def search
    @keyword = params[:keyword].strip
    @articles = FArticle.where("title like ?", "%#{@keyword}%").select(:id,:title,:tags,:img_url,:description,:category_id,:source_id).order("source_id desc").paginate(page: params[:page])
    if @articles.nil? || @articles.size.zero? && params[:page].nil?
      render json: {status: 0}
      return
    end
    render json: {status: 1, data: @articles}
  end

  def cards
    @cards = FCard.select(:id, :name, :avatar, :stars)
    render json: {status: 1, data: @cards}
  end

  def card
    @card = FCard.where(id: params[:id].to_i).take
    if @card
      render json: {status: 1, data: @card}
    else
      render json: {status: 0}
    end
  end

end

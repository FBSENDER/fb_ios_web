require 'gongzhu'
class YuanshenController < ApplicationController
  def cards
    cards = YsCard.where(card_type: params[:card_type].to_i).select(:id, :name, :avatar, :fenlei, :article_id).order(:id).to_a
    types = cards.map{|c| c.fenlei}.uniq
    render json: {cards: cards, types: types}
  end
  def article
    @article = YsArticle.where(id: params[:id].to_i).take
    if @article.nil?
      render json: {status: 0}
      return
    end
    @next = YsArticle.where("id > ? and category_id = ?", @article.id, @article.category_id).order("id").select(:id, :title).take
    @pre = YsArticle.where("id < ? and category_id = ?", @article.id, @article.category_id).order("id desc").select(:id, :title).take
    render json: {status: 1, title: @article.title, tags: @article.tags.split(','), category_id: @article.category_id, content: JSON.parse(@article.article_content), next: @next, pre: @pre}
  end

  def article_list
    @articles = YsArticle.where(category_id: params[:category_id].to_i).select(:id,:title,:tags,:img_url,:description,:category_id,:source_id).order("source_id desc").paginate(page: params[:page])
    render json: {status: 1, data: @articles}
  end

  def search
    @keyword = params[:keyword].strip
    @articles = YsArticle.where("title like ?", "%#{@keyword}%").select(:id,:title,:tags,:img_url,:description,:category_id,:source_id).order("source_id desc").paginate(page: params[:page])
    if @articles.nil? || @articles.size.zero? && params[:page].nil?
      render json: {status: 0}
      return
    end
    render json: {status: 1, data: @articles}
  end

end

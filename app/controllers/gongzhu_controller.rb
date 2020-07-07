require 'gongzhu'
class GongzhuController < ApplicationController
  layout "pinglun_layout"
  def search
    tag = GArticleTag.where(name: params[:keyword]).take
    if tag
      redirect_to "/gongzhu/tag/#{URI.encode(tag.name)}/"
      return 
    end
    @keyword = params[:keyword].strip
    @articles = GArticle.where("title like ? and status = 1", "%#{@keyword}%").select(:id,:title,:tags,:img_url,:description,:category_id,:source_id).order("source_id desc").paginate(page: params[:page])
    if @articles.nil? || @articles.size.zero? && params[:page].nil?
      render json: {status: 0}
      return
    end
    render json: {status: 1, data: @articles}
  end

  def tag
    @tag = GArticleTag.where(name: params[:name]).take
    if @tag.nil?
      render json: {status: 0}
      return
    end
    @card = GCard.where(name: @tag.name).select(:id,:name,:img_url).take
    @articles = GArticle.where(status:1, id: @tag.relation_id.split(',')).select(:id,:title,:tags,:img_url,:description,:category_id,:source_id).order("source_id desc").paginate(page: params[:page])
    render json: {status: 1, card: @card, data: @articles}
  end

  def article
    @article = GArticle.where(id: params[:id].to_i).take
    if @article.nil?
      render json: {status: 0}
      return
    end
    @next = GArticle.where("id > ? and category_id = ? and status = 1", @article.id, @article.category_id).order("id").select(:id, :title).take
    @pre = GArticle.where("id < ? and category_id = ? and status = 1", @article.id, @article.category_id).order("id desc").select(:id, :title).take
    render json: {status: 1, title: @article.title, tags: @article.tags.split(','), category_id: @article.category_id, content: JSON.parse(@article.article_content), next: @next, pre: @pre}
  end

  def article_gonglve
    @articles = GArticle.where(category_id: 2, status: 1).select(:id,:title,:tags,:img_url,:description,:category_id,:source_id).order("source_id desc").paginate(page: params[:page])
    render json: {status: 1, data: @articles}
  end
  def article_news
    @articles = GArticle.where(category_id: 1, status: 1).select(:id,:title,:tags,:img_url,:description,:category_id,:source_id).order("source_id desc").paginate(page: params[:page])
    render json: {status: 1, data: @articles}
  end
  def article_wenda
    @articles = GArticle.where(category_id: 3, status: 1).select(:id,:title,:tags,:img_url,:description,:category_id,:source_id).order("source_id desc").paginate(page: params[:page])
    render json: {status: 1, data: @articles}
  end

  def card_1
    @cards = GCard.where(stars: 1).select(:id,:img_url,:name).order("id desc")
    render json: {status: 1, data: @cards}
  end
  def card_2
    @cards = GCard.where(stars: 2).select(:id,:img_url,:name).order("id desc")
    render json: {status: 1, data: @cards}
  end
  def card_3
    @cards = GCard.where(stars: 3).select(:id,:img_url,:name).order("id desc")
    render json: {status: 1, data: @cards}
  end
  def card
    @card = GCard.where(id: params[:id].to_i).take
    if @card.nil?
      render json: {status: 0}
      return
    end
    @base_info = JSON.parse(@card.base_info).map{|j| j.split('|')}
    @card_info = JSON.parse(@card.card_info).map{|j| j.split('|')}
    @shuxing_info = JSON.parse(@card.shuxing_info).map{|j| j.split('|')}
    @skill_info = JSON.parse(@card.skill_info).map{|j| j.split('|')}
    @ban_info = JSON.parse(@card.ban_info).map{|j| j.split('|')}
    @next = GCard.where("id > ?", @card.id).order("id").select(:id, :img_url, :name).take
    @pre = GCard.where("id < ?", @card.id).order("id desc").select(:id, :img_url, :name).take
    render json: {status: 1, img: @card.img_url, base: @base_info, card: @card_info, shuxing: @shuxing_info, skill: @skill_info, ban: @ban_info, next: @next, pre: @pre}
  end

  def pinglun
    @sid = "#{params[:type]}_#{params[:id]}"
  end
end

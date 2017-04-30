require 'wzry'
require 'net/http'
class WzryController < ApplicationController
  layout "wzry_layout"
  @@hero_list = nil
  @@rune_list = nil
  @@equip_list = nil

  @@huya_zhibo = [nil,nil,nil,nil,nil]

  def ali_search
    data = do_ali_search(params[:keyword], "wzry_app")
    if data["status"] != 'OK'
      redirect_to "#{URI.encode("/wzry/hot?message=没有找到...")}"
      return
    end
    items = data["result"]["items"]
    if items.size.zero?
      redirect_to "#{URI.encode("/wzry/hot?message=没有找到...")}"
      return
    end
    @articles = []
    items.each do |item|
      article = WzryArticle.new
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
    render "wzry/article_list"
  end

  def tag
    @tag = WzryArticleTag.where(name: params[:name]).take
    not_found if @tag.nil?
    @hero = WzryHero.where(name: params[:name]).select(:id,:name,:img_url,:section_1).take
    @articles = WzryArticle.where(status:1, id: @tag.relation_id.split(',')).select(:id,:title,:tags,:img_url,:description,:category_id).order("source_id desc").paginate(page: params[:page])
    @path = request.fullpath
    @is_ipad = is_ipad?
    if request.xhr?
      render partial: "article_list", locals: {articles: @articles}
      return 
    end
    render "article_list", layout: "wzry_tag_layout"
  end

  def collect
    @articles = WzryArticle.where(status:1, id: params[:ids].split(',').map{|id| id.to_i}).select(:id,:title,:tags,:img_url,:description,:category_id).order("source_id desc").paginate(page: params[:page])
    @path = request.fullpath
    @is_ipad = is_ipad?
    if request.xhr?
      render partial: "article_list", locals: {articles: @articles}
      return 
    end
    render "article_list"
  end

  def source
    article = WzryArticle.where(source_id: params[:id].to_i).take
    not_found if article.nil?
    redirect_to "/wzry/article/#{article.id}/"
  end
  def hero_source
    hero = WzryHero.where(source_id: params[:id].to_i).select(:id).take
    not_found if hero.nil?
    redirect_to "/wzrydb/hero/#{hero.id}/"
  end

  def article
    @article = WzryArticle.where(id: params[:id].to_i).take
    not_found if @article.nil?
    @contents = JSON.parse(@article.article_content)
    @path = request.fullpath
    @next = WzryArticle.where("id > ? and category_id = ? and status = 1", @article.id, @article.category_id).order("id").take
    @pre = WzryArticle.where("id < ? and category_id = ? and status = 1", @article.id, @article.category_id).order("id desc").take
    #@show_pinglun_ad = is_app_new? && @article.id == 5742
    @show_pinglun_ad = false
  end

  def article_list
    @category_id = params[:category_id] || 1
    @articles = WzryArticle.where(category_id: @category_id.to_i, status: 1).select(:id,:title,:tags,:img_url,:description,:category_id).order("source_id desc").paginate(page: params[:page])
    @path = request.fullpath
    @is_ipad = is_ipad?
    if request.xhr?
      render partial: "article_list", locals: {articles: @articles}
      return 
    end
    render "article_list"
  end

  def hero_list
    @heros = WzryVideoType.where(video_type: 0).select(:title,:img_url,:source_ids)
    @path = request.fullpath
  end

  def hot
    @path = request.fullpath
    @tags = WzryArticleTag.pluck(:name).sample(25)
  end

  def get_hero_list
    if @@hero_list.nil? || Time.now.to_i % 3600 < 2
      @@hero_list = WzryDbList.where(name: '英雄').take
    end
    @@hero_list
  end
  def get_equip_list
    if @@equip_list.nil? || Time.now.to_i % 3600 < 2
      @@equip_list = WzryDbList.where(name: '装备').take
    end
    @@equip_list
  end
  def get_rune_list
    if @@rune_list.nil? || Time.now.to_i % 3600 < 2
      @@rune_list = WzryDbList.where(name: '铭文').take
    end
    @@rune_list
  end

  def db_hero_list
    @list = get_hero_list
    @path = request.fullpath
    render "db_hero_list", layout: nil
  end

  def db_hero
    @list = get_hero_list
    @hero = WzryHero.where(id: params[:id].to_i).take
    not_found if @hero.nil?
    @path = request.fullpath
    render "db_hero", layout: nil
  end

  def db_equip_list
    @list = get_equip_list
    @path = request.fullpath
    render "db_equip_list", layout: nil
  end

  def db_equip
    @list = get_equip_list
    @equip = WzryEquip.where(id: params[:id].to_i).take
    not_found if @equip.nil?
    @path = request.fullpath
    render "db_equip", layout: nil
  end

  def db_rune_list
    @list = get_rune_list
    @path = request.fullpath
    render "db_rune_list", layout: nil
  end

  def qq_video_list
    @videos = WzryQqVideo.select(:id, :title, :img_url, :vlength, :views, :published_at).order("source_id desc").paginate(page: params[:page])
    @path = request.fullpath
    @is_ipad = is_ipad?
    if request.xhr?
      render partial: "video_list", locals: {videos: @videos}
      return 
    end
    render "video_list"
  end

  def qq_video_detail
    @video = WzryQqVideo.where(id: params[:id]).take
    not_found if @video.nil?
    @path = request.fullpath
    @next = WzryQqVideo.where("id > ? and status = 1", @video.id).order("id").take
    @pre = WzryQqVideo.where("id < ? and status = 1", @video.id).order("id desc").take
    render "video_detail"
  end

  def qq_video_search
    @keyword = params[:keyword].strip
    @videos = WzryQqVideo.where("title like ? and status = 1", "%#{@keyword}%").select(:id,:title,:img_url,:vlength,:views,:published_at).order("source_id desc").paginate(page: params[:page])
    @path = request.fullpath
    @is_ipad = is_ipad?
    if request.xhr?
      render partial: "video_list", locals: {videos: @videos}
      return 
    end
    render "video_list"
  end

  def qq_video_collect
    @videos = WzryQqVideo.where(id: params[:ids].split(',').map{|id| id.to_i}, status: 1).select(:id,:title,:img_url,:vlength,:views,:published_at).order("source_id desc").paginate(page: params[:page])
    @path = request.fullpath
    @is_ipad = is_ipad?
    if request.xhr?
      render partial: "video_list", locals: {videos: @videos}
      return 
    end
    render "video_list"
  end

  def qq_video_hot
  end

  def get_huya_zhibo(id)
    if @@huya_zhibo[id].nil? || @@huya_zhibo[id].size.zero? || Time.now.to_i % 60 < 2
      case id
      when 1 then url = "http://www.huya.com/cache.php?m=LiveList&do=getTagLiveByPage&gameId=2336&tagId=184&page=1"
      when 2 then url = "http://www.huya.com/cache.php?m=LiveList&do=getTagLiveByPage&gameId=2336&tagId=186&page=1"
      when 3 then url = "http://www.huya.com/cache.php?m=LiveList&do=getTagLiveByPage&gameId=2336&tagId=187&page=1"
      when 4 then url = "http://www.huya.com/cache.php?m=LiveList&do=getTagLiveByPage&gameId=2336&tagId=188&page=1"
      when 5 then url = "http://www.huya.com/cache.php?m=LiveList&do=getLiveListByPage&gameId=2736&tagAll=0&page=1"
      end
      data =JSON.parse(Net::HTTP.get(URI(URI.encode(url))))
      if data["status"] == 200
        @@huya_zhibo[id] = data["data"]["datas"]
      else
        @@huya_zhibo[id] = []
      end
    end
    @@huya_zhibo[id]
  end

  def huya_list
    @details = get_huya_zhibo(params[:id].to_i)
    @path = request.fullpath
    @title = "虎牙直播"
  end

  def huya_detail
    @title = "观看直播"
    @path = request.fullpath
  end
end

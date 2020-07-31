require 'pic'

class PicController < ApplicationController
  $brands = PicBrand.all.to_a
  $brandss = PicBrandS.all.to_a
  $rversion = "1.0"

  def haokan_videos
    @videos = PicHaokanVideo.select(:id, :source_id, :title,:url,:img_url,:duration,:published,:read_num, :author).order("id").paginate(page: params[:page])
    render json: {status: 1, data: @videos}
  end

  def yongyi_haokan_videos
    @videos = YongyiHaokanVideo.select(:id, :source_id, :title,:url,:img_url,:duration,:published,:read_num, :author).order("id").paginate(page: params[:page])
    render json: {status: 1, data: @videos}
  end

  def build_result(topics, r = false)
    result = []
    topics.each do |t|
      brand = r ? $brandss.select{|b| b.id == t.brand_id}.first : $brands.select{|b| b.id == t.brand_id}.first
      next if brand.nil?
      result << {topic_id: t.id, brand_id: t.brand_id, brand_name: brand.tag_pinyin, img_dir: t.img_dir, img_count: t.img_count, thumb_url: t.thumb_url, avatar_url: brand.avatar_url, published_at: t.published_at.strftime("%Y-%m-%d")}
    end
    return result
  end

  def home
    page = params[:page] || 0
    page = page.to_i
    r = params[:version] == $rversion
    if r
      topics = PicTopicS.select(:id,:brand_id,:img_dir,:img_count,:thumb_url,:published_at).order("source_id desc").offset(10 * page).limit(10).to_a
    else
      #topics = PicTopic.where(status: 1).select(:id,:brand_id,:img_dir,:img_count,:thumb_url,:published_at).order("source_id desc").offset(10 * page).limit(10).to_a
      topics = PicTopic.select(:id,:brand_id,:img_dir,:img_count,:thumb_url,:published_at).order("source_id desc").offset(10 * page).limit(10).to_a
    end
    result = build_result(topics, r)
    render json: {status: 1, result: result}
  end

  def brand
    #ids = PicTopic.where(status: 1).pluck(:brand_id).uniq
    ids = PicTopic.pluck(:brand_id).uniq
    brands = PicBrand.where(id: ids).to_a
    render json: {status: 1, result: brands}
  end

  def brand_topics
    page = params[:page] || 0
    page = page.to_i
    r = params[:version] == $rversion
    if r
      topics = PicTopicS.where(brand_id: params[:id].to_i).select(:id,:brand_id,:img_dir,:img_count,:thumb_url,:published_at).order("source_id desc").offset(10 * page).limit(10).to_a
    else
      #topics = PicTopic.where(brand_id: params[:id].to_i, status: 1).select(:id,:brand_id,:img_dir,:img_count,:thumb_url,:published_at).order("source_id desc").offset(10 * page).limit(10).to_a
      topics = PicTopic.where(brand_id: params[:id].to_i).select(:id,:brand_id,:img_dir,:img_count,:thumb_url,:published_at).order("source_id desc").offset(10 * page).limit(10).to_a
    end
    result = build_result(topics, r)
    render json: {status: 1, result: result}
  end

  def category_topics
    page = params[:page] || 0
    page = page.to_i
    page = page < 0 ? 0 : page
    if params[:level].to_i == 1
      topics = PicNewTopic.where(cat_1_pinyin: params[:category]).select(:source_id, :thumb_url, :status, :img_dir, :img_count).order("source_id desc").offset(10 * page).limit(10).to_a
    elsif params[:level].to_i == 2
      topics = PicNewTopic.where(cat_2_pinyin: params[:category]).select(:source_id, :thumb_url, :status, :img_dir, :img_count).order("source_id desc").offset(10 * page).limit(10).to_a
    else
      render json: {status: 0}
      return
    end
    if topics.size.zero?
      render json: {status: 0}
      return
    end
    render json: {status: 1, result: topics}
  end

  def search_topics
    page = params[:page] || 0
    page = page.to_i
    page = page < 0 ? 0 : page
    if params[:keyword]
      brand_ids = PicBrand.where("tag_pinyin like ?", "%#{params[:keyword]}%").pluck(:id)
      if brand_ids.size.zero?
        render json: {status: 0}
        return
      end
      topics = PicTopic.where(brand_id: brand_ids, status: 1).where("published_at between ? and ?", params[:bt], params[:et]).order("source_id desc").offset(10 * page).limit(10)
    else
      topics = PicTopic.where("status = 1 and published_at between ? and ?", params[:bt], params[:et]).order("source_id desc").offset(10 * page).limit(10)
    end
    if topics.size.zero?
      render json: {status: 0}
      return
    end
    result = build_result(topics)
    render json: {status: 1, result: result}
  end

  def version
    render json: {status: 1, version: PicVersion.take.version}
  end

  def enable_topic
    t = PicTopic.where(id: params[:id].to_i).take
    if t
      t.status = 1
      t.save
    end
    render json: {status: 1}
  end

  def disable_topic
    t = PicTopic.where(id: params[:id].to_i).take
    if t
      t.status = -1
      t.save
    end
    render json: {status: 1}
  end

  def shenhe_topic_list
    page = params[:page] || 0
    page = page.to_i
    page = page < 0 ? 0 : page
    @topics = PicTopic.where(status: 1).select(:id,:brand_id,:img_dir,:img_count,:thumb_url,:published_at).order("source_id desc").offset(40 * page).limit(40).to_a
  end


end

require 'pic'

class PicController < ApplicationController
  $brands = PicBrand.all.to_a
  $brandss = PicBrandS.all.to_a
  $rversion = "1.0"

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
      topics = PicTopicS.select(:id,:brand_id,:img_dir,:img_count,:thumb_url,:published_at).order("source_id desc").offset(20 * page).limit(20).to_a
    else
      topics = PicTopic.select(:id,:brand_id,:img_dir,:img_count,:thumb_url,:published_at).order("source_id desc").offset(20 * page).limit(20).to_a
    end
    result = build_result(topics, r)
    render json: {status: 1, result: result}
  end

  def brand
    page = params[:page] || 0
    page = page.to_i
    r = params[:version] == $rversion
    if r
      render json: {status: 1, result: $brandss}
    else
      render json: {status: 1, result: $brands}
    end
  end

  def brand_topics
    page = params[:page] || 0
    page = page.to_i
    r = params[:version] == $rversion
    if r
      topics = PicTopicS.where(brand_id: params[:id].to_i).select(:id,:brand_id,:img_dir,:img_count,:thumb_url,:published_at).order("source_id desc").offset(20 * page).limit(20).to_a
    else
      topics = PicTopic.where(brand_id: params[:id].to_i).select(:id,:brand_id,:img_dir,:img_count,:thumb_url,:published_at).order("source_id desc").offset(20 * page).limit(20).to_a
    end
    result = build_result(topics, r)
    render json: {status: 1, result: result}
  end

  def version
    render json: {status: 1, version: PicVersion.take.version}
  end

end

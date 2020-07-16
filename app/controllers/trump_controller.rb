require 'trump'
class TrumpController < ApplicationController

  def haokan_videos
    @videos = TrumpVideo.select(:id, :source_id, :title,:url,:img_url,:duration,:published,:read_num, :author).order("id").paginate(page: params[:page])
    render json: {status: 1, data: @videos}
  end
end

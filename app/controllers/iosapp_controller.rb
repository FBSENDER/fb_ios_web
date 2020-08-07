require 'iosapp'
class IosappController < ApplicationController
  skip_before_action :verify_authenticity_token

  $ios_app_ids = %(1519578790 1517830498 1516808404 1522189191)
  $ios_product_ids = %w(yongyi_month_1 yongyi_year_1)

  def coupon_orders
    app_id = params[:app_id] ? params[:app_id] : ""
    unless $ios_app_ids.include?(app_id)
      render json: {status: 0}
      return
    end
    uuid = params[:uuid] ? params[:uuid] : ""
    if uuid.size != 36
      render json: {status: 0}
      return
    end
    user = IOSUser.where(ios_uuid: uuid, app_id: app_id).take
    if user.nil?
      render json: {status: 0}
      return
    end
    orders = IOSCouponOrder.where(user_id: user.id).to_a
    render json: {status: 1, orders: orders}
  end

  def coupon_order_finish
    app_id = params[:app_id] ? params[:app_id] : ""
    unless $ios_app_ids.include?(app_id)
      render json: {status: 0}
      return
    end
    uuid = params[:uuid] ? params[:uuid] : ""
    if uuid.size != 36
      render json: {status: 0}
      return
    end
    user = IOSUser.where(ios_uuid: uuid, app_id: app_id).take
    if user.nil?
      render json: {status: 0}
      return
    end
    order = IOSCouponOrder.where(id: params[:order_id].to_i, user_id: user.id).take
    if order
      order.status = 1
      order.save
      user.level = 1
      user.save
      user_log(user, 2)
      render json: {status: 1}
    else
      render json: {status: 0}
    end
  end
  def coupon_order_create
    app_id = params[:app_id] ? params[:app_id] : ""
    unless $ios_app_ids.include?(app_id)
      render json: {status: 0}
      return
    end
    uuid = params[:uuid] ? params[:uuid] : ""
    if uuid.size != 36
      render json: {status: 0}
      return
    end
    user = IOSUser.where(ios_uuid: uuid, app_id: app_id).take
    if user.nil?
      render json: {status: 0}
      return
    end
    if params[:ios_product_id].nil? || params[:item_id].nil? || params[:item_title].nil? || params[:item_img].nil? || params[:item_shop_title].nil? || params[:item_coupon].nil?
      render json: {status: 0}
      return
    end
    order = IOSCouponOrder.new
    order.user_id = user.id
    order.ios_product_id = params[:ios_product_id]
    order.item_id = params[:item_id]
    order.item_title = params[:item_title]
    order.item_img = params[:item_img]
    order.item_shop_title = params[:item_shop_title]
    order.item_coupon = params[:item_coupon]
    order.save
    render json: {status: 1, order: order}
  end

  def order_finish
    app_id = params[:app_id] ? params[:app_id] : ""
    unless $ios_app_ids.include?(app_id)
      render json: {status: 0}
      return
    end
    uuid = params[:uuid] ? params[:uuid] : ""
    if uuid.size != 36
      render json: {status: 0}
      return
    end
    product_id = params[:product_id] ? params[:product_id] : ""
    unless $ios_product_ids.include?(product_id)
      render json: {status: 0}
      return
    end
    tid = params[:tid] ? params[:tid] : ""
    if tid.size.zero?
      render json: {status: 0}
      return
    end
    user = IOSUser.where(ios_uuid: uuid, app_id: app_id).take
    if user
      order = IOSOrder.new
      order.user_id = user.id
      order.product_id = product_id
      order.transaction_id = tid
      order.save
      user.vip = 1
      user.vip_check = Time.now.to_i + 3600 * 24 * 7
      user.save
      render json: {status: 1}
    else
      render json: {status: 0}
    end
  end

  def user_login_again(user)
    user.ins += 1
    user.last_login = Time.now
    user.save
  end

  def user_log(user, type)
    log = IOSUserLog.new
    log.user_id = user.id
    log.op_type = type
    log.save
  end

  def user_login
    app_id = params[:app_id] ? params[:app_id] : ""
    unless $ios_app_ids.include?(app_id)
      render json: {status: 0}
      return
    end
    uuid = params[:uuid] ? params[:uuid] : ""
    if uuid.size != 36
      render json: {status: 0}
      return
    end
    user = IOSUser.where(ios_uuid: uuid, app_id: app_id).take
    if user
      render json: {status: 1, user_id: user.id, level: user.level, code: user.ios_code, invite_by: user.invite_code, invite_num: user.invite_num, vip: user.vip, need_check: user.vip_check!= 0 && user.vip_check < Time.now.to_i ? 1 : 0, guide: params[:version] == "1.1" ? 0 : 1}
      user_log(user, 1)
      user_login_again(user)
      return
    else
      user = new_user(uuid, app_id)
      user_log(user, 1)
      render json: {status: 1, user_id: user.id, level: 0, code: user.ios_code, invite_by: user.invite_code, invite_num: user.invite_num, guide: params[:version] == "1.1" ? 0 : 1}
    end
  end

  def refresh_user_info
    app_id = params[:app_id] ? params[:app_id] : ""
    unless $ios_app_ids.include?(app_id)
      render json: {status: 0}
      return
    end
    uuid = params[:uuid] ? params[:uuid] : ""
    if uuid.size != 36
      render json: {status: 0}
      return
    end
    user = IOSUser.where(ios_uuid: uuid, app_id: app_id).take
    if user
      render json: {status: 1, user_id: user.id, level: user.level, code: user.ios_code, invite_by: user.invite_code, invite_num: user.invite_num, vip: user.vip, need_check: user.vip_check!= 0 && user.vip_check < Time.now.to_i ? 1 : 0}
    else
      render json: {status: 0}
    end
  end

  def do_invited
    app_id = params[:app_id] ? params[:app_id] : ""
    unless $ios_app_ids.include?(app_id)
      render json: {status: 0}
      return
    end
    uuid = params[:uuid] ? params[:uuid] : ""
    if uuid.size != 36
      render json: {status: 0}
      return
    end
    code = params[:code] ? params[:code].upcase : ""
    if code.size != 5
      render json: {status: 0}
      return
    end
    user = IOSUser.where(ios_uuid: uuid, app_id: app_id).take
    if user.nil? || user.invite_code != "" || user.ios_code == code
      render json: {status: 0}
      return
    end
    invited_by = IOSUser.where(ios_code: code).take
    if invited_by.nil?
      render json: {status: 0}
      return
    end
    user.invite_code = code
    user.save
    invited_by.invite_num += 1
    invited_by.save
    render json: {status: 1}
  end

  def new_user(uuid, app_id)
    begin
      user = IOSUser.new
      user.ios_uuid = uuid
      user.app_id = app_id
      user.ins = 1
      user.last_login = Time.now
      user.ios_code = gen_ioscode
      user.invite_code = ""
      user.invite_num = 0
      user.save
      user
    rescue
      puts "new user error"
      return new_user(uuid, app_id)
    end
  end

  def gen_ioscode
    w = %w(0 1 2 3 4 5 6 7 8 9 Q W E R T Y U I O P A S D F G H J K L Z X C V B N M)
    code = ""
    loop do
      code += w.sample
      break if code.size >= 5
    end
    code
  end

  def ipa
    render plain: params[:d]
  end

  def ios_receipt
    app_id = params[:app_id] ? params[:app_id] : ""
    unless $ios_app_ids.include?(app_id)
      render json: {status: 0}
      return
    end
    uuid = params[:uuid] ? params[:uuid] : ""
    if uuid.size != 36
      render json: {status: 0}
      return
    end
    user = IOSUser.where(ios_uuid: uuid, app_id: app_id).take
    if user
      r = IOSReceipt.where(user_id: user.id).take || IOSReceipt.new
      r.user_id = user.id
      r.receipt = params[:receipt]
      r.save
      render json: {status: 1}
    else
      render json: {status: 0}
    end
  end

  def fav_domains
    data = FavDomain.all.to_a
    render json: {status: 1, result: data}
  end

  def new_fav_tag
    domain = params[:domain_id].to_i
    name = params[:tag] ? params[:tag].strip : ""
    if domain == 0 || name.empty?
      render json: {status: 0}
      return
    end
    t = FavVideoTag.where(name: name, domain_id: domain).take
    if t
      render json: {status: 1, result: t}
    else
      t = FavVideoTag.new
      t.name = name
      t.domain_id = domain
      t.save
      render json: {status: 1, result: t}
    end
  end

  def domain_tags
    tags = FavVideoTag.where(domain_id: params[:domain_id].to_i)
    render json: {status: 1, result: tags}
  end

  def new_fav_video
    begin
      v = FavVideo.where(source_id: params[:source_id]).take
      if v.nil?
        v = FavVideo.new
        v.source_id = params[:source_id]
        v.source_site = params[:source_site]
        v.tags = ""
        v.title = params[:title]
        v.url = params[:url]
        v.img_url = params[:img_url]
        v.duration = params[:duration]
        v.published = params[:published]
        v.read_num = params[:read_num]
        v.author = params[:author]
        v.save
      end
      tag = FavVideoTag.where(id: params[:tag_id].to_i).take
      if tag.nil? || tag.name != params[:tag_name]
        render json: {status: 0}
        return
      end
      r = FavRelation.where(video_id: v.id, tag_id: params[:tag_id].to_i).take
      if r.nil?
        r = FavRelation.new
        r.tag_id = tag.id
        r.video_id = v.id
        r.sort = 1000
        r.save
      end
      tags = v.tags.split(',')
      tags << tag.name
      tags = tags.uniq
      v.tags = tags.join(',')
      v.save
      render json: {status: 1}
    rescue
      render json: {status: 0}
    end
  end

  def fav_video
    v = FavVideo.where(source_id: params[:source_id]).take
    if v
      render json: {status: 1, result: v}
    else
      render json: {status: 0}
    end
  end

  def fav_video_tag
    t = FavVideoTag.where(name: params[:tag]).take
    if t.nil?
      render json: {status: 0}
      return
    end
    page = params[:page].to_i
    page = 0 if page < 0
    vids = FavRelation.where(tag_id: t.id).order("sort asc, id desc").offset(page * 20).limit(20).pluck(:video_id)
    videos = FavVideo.where(id: vids).to_a
    render json: {status: 1, result: videos}
  end
  
  def top_fav_video_tag
    r = FavRelation.where(video_id: params[:video_id].to_i, tag_id: params[:tag_id].to_i).take
    if r
      r.sort = 0
      r.save
      render json: {status: 1}
    else
      render json: {status: 0}
    end
  end

  def top_fav_video
    FavRelation.where(video_id: params[:video_id].to_i).each do |r|
      r.sort = 0
      r.save
    end
    render json: {status: 1}
  end

end

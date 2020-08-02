require 'iosapp'
class IosappController < ApplicationController
  skip_before_action :verify_authenticity_token

  $ios_app_ids = %(1519578790 1517830498 1516808404 1522189191)

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
      render json: {status: 1, user_id: user.id, level: user.level, code: user.ios_code, invite_by: user.invite_code, invite_num: user.invite_num}
      user_log(user, 1)
      user_login_again(user)
      return
    else
      user = new_user(uuid, app_id)
      user_log(user, 1)
      render json: {status: 1, user_id: user.id, level: 0, code: user.ios_code, invite_by: user.invite_code, invite_num: user.invite_num}
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
      render json: {status: 1, user_id: user.id, level: user.level, code: user.ios_code, invite_by: user.invite_code, invite_num: user.invite_num}
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

end

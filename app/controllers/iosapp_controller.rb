require 'iosapp'
class IosappController < ApplicationController

  def coupon_order_create
    app_id = params[:app_id] ? params[:app_id] : ""
    unless %w(1519578790).include?(app_id)
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
    unless %w(1519578790).include?(app_id)
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
      render json: {status: 1, user_id: user.id}
      user_log(user, 1)
      user_login_again(user)
      return
    else
      user = IOSUser.new
      user.ios_uuid = uuid
      user.app_id = app_id
      user.ins = 1
      user.last_login = Time.now
      user.save
      user_log(user, 1)
      render json: {status: 1, user_id: user.id}
    end
  end

end

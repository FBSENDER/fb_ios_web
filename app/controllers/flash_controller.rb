require 'ssflash'
class FlashController < ApplicationController
  skip_before_action :verify_authenticity_token, :only => [:users, :traffic_cost, :ipn_notify,:user_cstring, :pia_notify]

  def is_user_validity?
    is_inapp? && app_uuid == params[:uuid]
  end

  def is_in_china
    if is_in_china?
      render plain: "1"
    else
      render plain: "0"
    end
  end
  
  #分享页，功能介绍，微信浏览器打开，判断UA跳app store
  def tuiguang
  end

  #用户首页
  def user_home
    #使用方法介绍
    #剩余流量
    #签到
    unless is_user_validity?
      render :nothing => true, :status => 403
      return
    end
    @user = FUser.where(default_uuid: params[:uuid]).take
    @is_new = false
    if @user.nil?
      @user = create_new_user(params[:uuid])
      @is_new = true
    end
    @checked = @user.last_check_in_time > Date.today.to_time.to_i
    active_user(@user)
  end

  # 用户连接串
  def user_cstring
    unless is_user_validity?
      render :nothing => true, :status => 403
      return
    end
    @user = FUser.where(default_uuid: params[:uuid]).take
    if @user.nil?
      render :plain => "server_name|127.0.0.1|3000|321321|rc4-md5"
      return
    end
    if is_in_china?
      server_ip = FNode.where("status = 1").pluck(:server_ip).sample
    else
      server_ip = "47.90.13.15"
    end
    if server_ip.nil?
      render :plain => "server_name|127.0.0.1|3000|321321|rc4-md5"
      return
    end
    active_user(@user)
    pt = FPortUser.where(user_id: @user.id).take
    if pt.nil?
      render :plain => "server_name|127.0.0.1|3000|321321|rc4-md5"
      return
    end
    @port = FActivePort.where(port: pt.port).take
    if @port.nil?
      render :plain => "server_name|127.0.0.1|3000|321321|rc4-md5"
      return
    end
    render :plain => "server_name|#{server_ip}|#{@port.port}|#{@port.passwd}|rc4-md5"
  end

  #用户签到
  def user_check_in
    unless is_user_validity?
      render :nothing => true, :status => 403
      return
    end
    @user = FUser.where(default_uuid: params[:uuid]).take
    not_found if @user.nil?
    if @user.last_check_in_time > Date.today.to_time.to_i
      redirect_to "/flash/#{params[:uuid]}"
      return
    end
    gift = [6,7,8,9,10].sample * 1048576
    @user.last_check_in_time = Time.now.to_i
    @user.gift_transfer += gift
    @user.transfer_enable += gift
    @user.last_gift_transfer = gift
    @user.check_in_times += 1
    @user.save
    redirect_to "/flash/#{params[:uuid]}"
  end

  # 流量购买
  def purchase
    unless is_user_validity?
      render :nothing => true, :status => 403
      return
    end
    @user = FUser.where(default_uuid: params[:uuid]).take
    not_found if @user.nil?
    active_user(@user)
    @products = FProduct.where(status: 1).order(:id)
  end

  # pia
  def purchase_in_app
    unless is_user_validity?
      render :nothing => true, :status => 403
      return
    end
    @user = FUser.where(default_uuid: params[:uuid]).take
    not_found if @user.nil?
    @products = FInappProduct.where(status: 1).to_a
  end

  def purchase_in_app_log
    unless is_user_validity?
      render :nothing => true, :status => 403
      return
    end
    @user = FUser.where(default_uuid: params[:uuid]).take
    not_found if @user.nil?
    @logs = FPiaMessage.where(user_id: @user.id, status: [0,1,2]).order("id desc")
    @products = FInappProduct.where(status: 1).pluck(:title,:price,:ios_product_id)
  end

  def pia_notify
    unless is_user_validity?
      render :nothing => true, :status => 403
      return
    end
    @user = FUser.where(default_uuid: params[:uuid]).take
    not_found if @user.nil?
    @message = FPiaMessage.where(transaction_id: params[:transaction_id]).take
    if @message
      if [0,1,2].include?(@message.status)
        render json: {status: 1}
      else
        render json: {status: 0}
      end
      return
    end
    message = FPiaMessage.new
    message.user_id = @user.id
    message.ios_product_id = params[:ios_product_id].to_s
    message.is_sandbox = params[:is_sandbox].to_i
    message.receipt = params[:message]
    message.check_field = params[:check].to_i
    message.transaction_id = params[:transaction_id]
    message.status = 0
    message.save
    if message.is_verified?
      render json: {status: 1}
      message.status = 1
      message.save
    else
      render json: {status: 0}
      message.status = -1
      message.save
    end
  end

  # 流量消耗记录
  def traffic_log
    unless is_user_validity?
      render :nothing => true, :status => 403
      return
    end
    @user = FUser.where(default_uuid: params[:uuid]).take
    not_found if @user.nil?
    active_user(@user)
    @logs = FTrafficLog.where(user_id: @user.id).select(:log_time, :traffic_cost).order("id desc").limit(100)
  end

  def ipn_notify
    txn_id = params['txn_id']
    payment_status = params['payment_status']

    #只存储支付完成的ipn
    if payment_status != 'Completed'
      render :nothing => true, :status => 200, :content_type => 'text/html'
      return
    end

    #txn_id 为空则不处理
    if txn_id.nil?
      render_nothing
      return
    end

    message = FIpnMessage.where(txn_id: txn_id).take
    unless message.nil?
      message.post_count += 1
      message.save
      render :nothing => true, :status => 200, :content_type => 'text/html'
      return
    end

    custom_data = params['custom'] || '0,0'
    custom = custom_data.split(',')

    message = FIpnMessage.new
    message.txn_id = txn_id || ''
    message.post_count = 1
    message.user_id = custom[0] || 0
    message.product_id = custom[1] || 0
    message.status = 0
    message.receiver_email = params['receiver_email'] || ''
    message.payer_email = params['payer_email'] || ''
    message.mc_gross = params['mc_gross'] || 0
    message.mc_fee = params['mc_fee'] || 0
    message.mc_currency = params['mc_currency'] || ''
    message.payment_status = params['payment_status'] || ''
    message.payment_date = params['payment_date'] || ''
    message.original_post_params = params.map{|key,value| "#{key}=#{value}"}[0..-3].join('&')
    message.save
    render :nothing => true, :status => 200, :content_type => 'text/html'
    if message.is_verified?
      message.status = 1
      message.save
    else
      message.status = -1
      message.save
    end
  end

  def users
    unless is_valid_ss_node?
      render :nothing => true, :status => 403
      return
    end
    #users = FUser.all.pluck(:port, :u, :d, :transfer_enable, :passwd, :switch, :enable)
    users = FActivePort.pluck(:port,:passwd).map{|item| [item[0], 0, 0, 100, item[1], 1, 1]}
    render :json => users.to_json
  end

  def traffic_cost
    unless is_valid_ss_node?
      render :nothing => true, :status => 403
      return
    end
    cost_data = params[:user_traffic_cost]
    if cost_data.nil?
      render :nothing => true, :status => 200
      return
    end
    cost_data.split('|').each do |port_cost|
      port,cost,time = port_cost.split(',')
      pt = FPortUser.where(port: port.to_i).take
      user = FUser.where(id: pt.user_id).take
      next if user.nil?
      user.d += cost.to_i
      user.enable = 0 if user.d > user.transfer_enable
      user.t = time.to_i
      user.last_active_time = Time.now.to_i
      user.save
      traffic_log = FTrafficLog.new
      traffic_log.user_id = user.id
      traffic_log.server_ip = request.remote_ip
      traffic_log.port = port.to_i
      traffic_log.traffic_cost = cost.to_i
      traffic_log.log_time = Time.now
      traffic_log.save
    end
    render :text => 'success'
  end

  private
  def create_new_user(uuid)
    user = FUser.new
    user.default_uuid = uuid
    user.default_name = ''
    user.ios_uuid = ''
    user.port = 4199
    user.passwd = gen_random_pass
    user.youhuima = gen_random_pass
    user.t = 0
    user.u = 0
    user.d = 0
    # 送 100 M
    user.transfer_enable = 104857600
    user.enable = 1
    user.switch = 1
    user.user_type = 0
    user.last_check_in_time = 0
    user.last_active_time = Time.now.to_i
    user.save
    init_user_port(user)
    user
  end

  private
  def init_user_port(user)
    user.port = user.id + 4200
    user.save
  end

  private 
  def gen_random_pass
    %w(1 2 3 4 5 6 7 8 9 0 ! @ # $ % ^ & * q w e r t y u i o p a s d f g h j k l z x c v b n m).sample(6).join
  end

  def is_valid_ss_node?
    server_ips = FNode.where("status = 1").pluck(:server_ip)
    server_ips.include?(request.remote_ip)
  end

  def active_user(user)
    if user.switch == 1
      user.last_active_time = Time.now
      user.save
    else
      user.last_active_time = Time.now
      user.switch = 1
      user.save
    end

    # bind user to active port
    return if user.enable != 1
    r1 = FPortUser.where(user_id: user.id).take
    if r1.nil?
      r2 = FPortUser.where(user_id: 0).first
      return if r2.nil?
      r2.user_id = user.id
      r2.save
    end
  end
end

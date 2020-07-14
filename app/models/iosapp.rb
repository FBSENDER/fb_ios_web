class IOSUser < ActiveRecord::Base
  self.table_name = 'iosapp_users'
end

class IOSUserLog < ActiveRecord::Base
  self.table_name = 'iosapp_user_logs'
end

class IOSCouponOrder < ActiveRecord::Base
  self.table_name = 'iosapp_coupon_orders'
end

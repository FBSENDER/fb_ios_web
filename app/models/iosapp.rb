class IOSUser < ActiveRecord::Base
  self.table_name = 'iosapp_users'
end

class IOSUserLog < ActiveRecord::Base
  self.table_name = 'iosapp_user_logs'
end

class IOSCouponOrder < ActiveRecord::Base
  self.table_name = 'iosapp_coupon_orders'
end

class IOSOrder < ActiveRecord::Base
  self.table_name = 'iosapp_orders'
end

class IOSReceipt < ActiveRecord::Base
  self.table_name = 'iosapp_receipts'
end

class FavDomain < ActiveRecord::Base
  self.table_name = 'fav_domains'
end

class FavVideoTag < ActiveRecord::Base
  self.table_name = 'fav_video_tags'
end

class FavVideo < ActiveRecord::Base
  self.table_name = 'fav_videos'
end

class FavRelation < ActiveRecord::Base
  self.table_name = 'fav_video_tag_relations'
end

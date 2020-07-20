class PicBrand < ActiveRecord::Base
  self.table_name = 'pic_brands'
end

class PicTopic < ActiveRecord::Base
  self.table_name = 'pic_topics'
end

class PicBrandS < ActiveRecord::Base
  self.table_name = 'pic_brands_s'
end

class PicTopicS < ActiveRecord::Base
  self.table_name = 'pic_topics_s'
end

class PicVersion < ActiveRecord::Base
  self.table_name = 'pic_versions'
end

class PicCategory < ActiveRecord::Base
  self.table_name = 'pic_categories'
end

class PicNewTopic < ActiveRecord::Base
  self.table_name = "pic_new_topics"
end

class PicHaokanVideo < ActiveRecord::Base
  self.table_name = "pic_haokan_videos"
end

class YongyiHaokanVideo < ActiveRecord::Base
  self.table_name = "yongyi_haokan_videos"
end

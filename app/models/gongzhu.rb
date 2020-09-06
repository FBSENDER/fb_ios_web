class GCard < ActiveRecord::Base
  self.table_name = 'game_gongzhu_cards'
end
class GArticle < ActiveRecord::Base
  self.table_name = 'game_gongzhu_articles'
end
class GArticleTag < ActiveRecord::Base
  self.table_name = 'game_gongzhu_article_tags'
end
class GVideo < ActiveRecord::Base
  self.table_name = 'game_gongzhu_haokan_videos'
end
class FCard < ActiveRecord::Base
  self.table_name = 'game_fangzhou_cards'
end
class FArticle < ActiveRecord::Base
  self.table_name = 'game_fangzhou_articles'
end
class FArticleTag < ActiveRecord::Base
  self.table_name = 'game_fangzhou_article_tags'
end
class YArticle < ActiveRecord::Base
  self.table_name = 'game_yuanzheng_articles'
end
class YArticleTag < ActiveRecord::Base
  self.table_name = 'game_yuanzheng_article_tags'
end
class YCard < ActiveRecord::Base
  self.table_name = 'game_yuanzheng_cards'
end
class YFuben < ActiveRecord::Base
  self.table_name = 'game_yuanzheng_fubens'
end
class YsArticle < ActiveRecord::Base
  self.table_name = 'game_yuanshen_articles'
end
class YsArticleTag < ActiveRecord::Base
  self.table_name = 'game_yuanshen_article_tags'
end
class YsCard < ActiveRecord::Base
  self.table_name = 'game_yuanshen_cards'
end

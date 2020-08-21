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

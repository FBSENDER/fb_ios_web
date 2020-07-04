class GCard < ActiveRecord::Base
  self.table_name = 'game_gongzhu_cards'
end
class GArticle < ActiveRecord::Base
  self.table_name = 'game_gongzhu_articles'
end
class GArticleTag < ActiveRecord::Base
  self.table_name = 'game_gongzhu_article_tags'
end

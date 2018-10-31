class MrzhArticle < ActiveRecord::Base
    self.table_name = 'game_mrzh_articles'
end

class MrzhArticleTag < ActiveRecord::Base
    self.table_name = 'game_mrzh_article_tags'
end

class MrzhArticleCategory < ActiveRecord::Base
  self.table_name = 'game_mrzh_article_categories'
end

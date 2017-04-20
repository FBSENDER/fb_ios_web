class GmdlArticle < ActiveRecord::Base
  self.table_name = 'game_gmdl_articles'
end

class GmdlArticleTag < ActiveRecord::Base
  self.table_name = 'game_gmdl_article_tags'
end

class GmdlZhiye < ActiveRecord::Base
  self.table_name = 'game_gmdl_zhiyes'
end

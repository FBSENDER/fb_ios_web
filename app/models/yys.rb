class Card < ActiveRecord::Base
  self.table_name = 'yys_cards'
end
class Article < ActiveRecord::Base
  self.table_name = 'yys_articles'
end
class ArticleCategory < ActiveRecord::Base
  self.table_name = 'yys_article_categories'
end
class ArticleTag < ActiveRecord::Base
  self.table_name = 'yys_article_tags'
end
class Yuhun < ActiveRecord::Base
  self.table_name = 'yys_yuhuns'
end

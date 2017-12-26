class HyxdArticle < ApplicationRecord
  self.table_name = 'hyxd_articles'
end

class HyxdArticleTag < ApplicationRecord
  self.table_name = 'hyxd_article_tags'
end

class HyxdEqp < ApplicationRecord
  self.table_name = 'hyxd_eqps'
end

class HyxdGun < ApplicationRecord
  self.table_name = 'hyxd_guns'
end

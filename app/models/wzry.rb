class WzryArticle < ActiveRecord::Base
    self.table_name = 'game_wzry_articles'
end

class WzryArticleTag < ActiveRecord::Base
    self.table_name = 'game_wzry_article_tags'
end

class WzryVideoType < ActiveRecord::Base
    self.table_name = 'game_wzry_video_types'
end

class WzryHero < ActiveRecord::Base
    self.table_name = 'game_wzry_heros'
end

class WzryEquip < ActiveRecord::Base
    self.table_name = 'game_wzry_equips'
end

class WzryDbList < ActiveRecord::Base
    self.table_name = 'game_wzry_db_list'
end

class WzryQqVideo < ActiveRecord::Base
    self.table_name = 'game_wzry_qq_videos'
end

class Blog < ActiveRecord::Base
  # Associations
  belongs_to :space
  has_many :articles

  # Callbacks
  after_create :create_page_for_blog
  
protected
  # after_create callback
  # Creates a page with same name as blog, and
  # associates it with the blog via behavior
  def create_page_for_blog
    space.pages.create! :name => name, :behavior => self,
      :template => 'blog.html.erb'
  end
  
public
  # Returns recently published articles
  def recent_articles(limit=5)
    articles.recent(limit)
  end
end

Space.has_many :blogs
class Blog < ActiveRecord::Base
  # Associations
  belongs_to :space
  has_many :articles
  has_one :page, :as => :behavior

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
end

Space.has_many :blogs
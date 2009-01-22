class BlogPlugin < Slate::Plugin
  name 'Blogs'
  description 'Create blogs for your site'
  
  navigation do |tabs|
    tabs.add 'Blogs', space_blogs_path(Space.active)
  end
  
  routes do |map|
    map.with_space do |space|
      space.resources :blogs do |blog|
        blog.resources :articles, :member => {
          :publish => :any, :unpublish => :any 
        }
      end
    end
  end
end
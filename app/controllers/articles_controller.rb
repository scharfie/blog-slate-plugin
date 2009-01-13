class ArticlesController < ResourcesController
  resources_controller_for :articles, :in => [:space, :blog]
  current_tab 'Blogs'
  include PeriodicalsHelper
  
protected
  def publish_resource!
    resource.publish!(resource.published_at)
  end
  
public
  # Replace the resource_url so that redirects
  # will go to the page (this way, the article
  # can be visible exactly as it will appear
  # on the blog)
  def resource_url(*args)
    space_page_url @space, @blog.page,
      hash_for_periodical_path(resource)
  end

  response_for :destroy do |wants|
    wants.html { redirect_to space_blogs_path }
  end
  
  # Publishes the article
  def publish
    self.resource = find_resource
    publish_resource!
    flash[:notice] = 'Succesfully published article!'
    redirect_to resource_url
  end
  
  # Unpublishes the article
  def unpublish
    self.resource = find_resource
    resource.unpublish!
    flash[:notice] = 'Successfully unpublished article!'
    redirect_to resource_url
  end
end
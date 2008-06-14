class ArticlesController < ApplicationController
  resources_controller_for :articles, :in => [:space, :blog]
  current_tab 'Blogs'
  
public
  # Publishes the article
  def publish
    self.resource = find_resource
    resource.publish!
    flash[:notice] = 'Succesfully published article!'
    redirect_to resource_path(resource)
  end
  
  # Unpublishes the article
  def unpublish
    self.resource = find_resource
    resource.unpublish!
    flash[:notice] = 'Successfully unpublished article!'
    redirect_to resource_path(resource)
  end
end

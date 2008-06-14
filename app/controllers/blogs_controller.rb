class BlogsController < Slate::Controller
  resources_controller_for :blogs, :in => :space
  
public
  def show
    redirect_to resource_articles_path(params[:id])
  end
end

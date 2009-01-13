class CommentsController < ResourcesController
  resources_controller_for :comments
  include PeriodicalsHelper
  
public
  response_for :create do |wants|
    wants.html { redirect_to :back }
  end
end

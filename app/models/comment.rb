class Comment < ActiveRecord::Base
  # Associations
  belongs_to :article
  
  # Validations
  validates_presence_of :name, :body
end

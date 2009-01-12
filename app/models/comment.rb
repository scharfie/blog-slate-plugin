class Comment < ActiveRecord::Base
  # Associations
  belongs_to :article
end

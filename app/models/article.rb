class Article < ActiveRecord::Base
  # Acts
  acts_as_published :versions => 1
  permalink_column :name, :glue => '-'
  compiled_column :body
  
  # Associations
  belongs_to :blog
  
public
  # Returns all year-months that articles were published on
  def self.archives
    self.find(:all,
      :select => "DISTINCT #{connection.year('published_at')} AS year, #{connection.month('published_at')} AS month",
      :conditions => ['published_at <= ? && version = 1', Time.now],
      :order => "published_at DESC"
    ).map { |e| Archive.new(Time.local(e.year, e.month)) }
  end 
  
  # Returns custom DOM ID
  def dom_id
    ['article', id].join('-')
  end
  
  class Archive
    delegate :year, :month, :eztime, :to => :date
    attr_accessor :date
    attr_accessor :permalink
    alias_method :published_at, :date
    
    def initialize(date)
      self.date = date.beginning_of_month
    end
  end
end

class Article < ActiveRecord::Base
  permalink_column :name, :glue => '-'
  compiled_column :body
  
  # Associations
  belongs_to :blog
  
  # Scopes
  named_scope :published, :conditions => ['published_at <= ?', Time.now],
    :order => 'published_at DESC'
  named_scope :updated, :conditions => ['updated_at <= ?', Time.now],
    :order => 'updated_at DESC'

public
  def self.find_by_date(year, month=nil, day=nil)
    conditions = [connection.year('published_at') + ' = ?']
    variables  = [year.to_i]
    
    if month
      conditions << connection.month('published_at') + ' = ?'
      variables  << month.to_i
      
      if day
        conditions << connection.day('published_at') + ' = ?'
        variables  << day.to_i
      end
    end
    
    find :all, :conditions => [conditions.join(' AND '), variables].flatten
  end
  
  # Returns all year-months that articles were published on
  def self.archives
    self.find(:all,
      :select => "DISTINCT #{connection.year('published_at')} AS year, #{connection.month('published_at')} AS month",
      :conditions => ['published_at <= ?', Time.now],
      :order => "published_at DESC"
    ).map { |e| Archive.new(Time.local(e.year, e.month)) }
  end 
  
  # Publishes the article
  def publish!
    update_attribute :published_at, Time.now
  end
  
  # Unpublishes the article
  def unpublish!
    update_attribute :published_at, nil
  end
  
  # Returns true if the article is published
  def published?
    published_at != nil
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

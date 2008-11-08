class Article < ActiveRecord::Base
  permalink_column :name, :glue => '-'
  compiled_column :body
  
  # Associations
  belongs_to :blog
  
  # Scopes
  named_scope :published, :conditions => ['published_on <= ?', Time.now],
    :order => 'published_on DESC'
  named_scope :updated, :conditions => ['updated_at <= ?', Time.now],
    :order => 'updated_at DESC'

public
  def self.find_by_date(year, month=nil, day=nil)
    conditions = [connection.year('published_on') + ' = ?']
    variables  = [year.to_i]
    
    if month
      conditions << connection.month('published_on') + ' = ?'
      variables  << month.to_i
      
      if day
        conditions << connection.day('published_on') + ' = ?'
        variables  << day.to_i
      end
    end
    
    find :all, :conditions => [conditions.join(' AND '), variables].flatten
  end
  
  # Returns all year-months that articles were published on
  def self.archives
    self.find(:all,
      :select => "DISTINCT #{connection.year('published_on')} AS year, #{connection.month('published_on')} AS month",
      :conditions => ['published_on <= ?', Time.now],
      :order => "published_on DESC"
    ).map { |e| Archive.new(Time.local(e.year, e.month)) }
  end 
  
  # Publishes the article
  def publish!
    update_attribute :published_on, Time.now
  end
  
  # Unpublishes the article
  def unpublish!
    update_attribute :published_on, nil
  end
  
  # Returns true if the article is published
  def published?
    published_on != nil
  end
  
  # Returns custom DOM ID
  def dom_id
    ['article', id].join('-')
  end
  
  class Archive
    delegate :year, :month, :eztime, :to => :date
    attr_accessor :date
    attr_accessor :permalink
    alias_method :published_on, :date
    
    def initialize(date)
      self.date = date.beginning_of_month
    end
  end
end

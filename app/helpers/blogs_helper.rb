module BlogsHelper
  # IDEA: abstract the periodical stuff into a DSL-like syntax:
  # 
  # periodicals_for :article, :scope => Proc.new { @blog.articles }
  #
  # def periodicals_resource_service
  #   @blog.articles
  # end

  # Renders blog
  def blog_engine
    if periodicals_by_day?
      '- Show articles for day'
      debug @blog.articles.find_by_date(params[:year], params[:month], params[:day])
    elsif periodicals_by_month?
      '- Show articles for month'
      show_articles_by_month
    elsif periodicals_by_year?
      '- Show articles for year'
      debug @blog.articles.find_by_date(params[:year])
    elsif periodicals_by_slug?
      show_article_by_slug
    else
      show_recent_articles
    end
  end
  
  def show_articles_by_month
    @articles = @blog.articles.published.on_date(params[:year], params[:month])
    @archive  = Article::Archive.new(Date.new(params[:year].to_i, params[:month].to_i, 1))
    partial :articles_by_month, :object => @articles
  end
  
  def show_article_by_slug
    @article = @blog.articles.published.find_by_permalink(params[:slug])
    if editor? && @article.nil?
      @article = @blog.articles.unpublished.find_by_permalink(params[:slug])
    end  
    partial :article, :object => @article
  end
  
  def show_recent_articles
    # scope = editor? && slate? ? :updated : :published
    @articles = @blog.articles.published.all(:limit => 5, :order => 'published_at DESC')
    partial :article, :collection => @articles
  end
  
  # Returns a link to article (using the article name for text)
  def article_link(article, options={})
    link_to options.delete(:text) || article.name, periodical_url(article, options)
  end
  
  # Returns nicely formatted date for the article's
  # published date
  def article_date(article, format=':nday, :nmonth :day:ordinal :year &mdash; :hour12::minute :meridian')
    (article.published_at || article.updated_at).eztime(format)
  end
  
  def article_tools(article)
    partial :article_tools, :locals => { :article => article }
  end
  
  def archive_date(format=':nmonth :year')
    @archive.eztime(format)
  end
end
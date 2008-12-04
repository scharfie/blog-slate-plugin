class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.integer :blog_id
      t.string :name
      t.string :permalink
      t.text :body
      t.text :body_html
      t.integer :article_id
      t.integer  :version,      :default => 0
      t.datetime :published_at
      t.timestamps
    end
  end

  def self.down
    drop_table :articles
  end
end

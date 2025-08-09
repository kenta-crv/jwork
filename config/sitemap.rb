# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://ri-plus.jp"

SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'

SitemapGenerator::Sitemap.create do

    add "/", changefreq: 'daily', priority: 1.0
    add "engilance" , changefreq: 'daily', priority: 0.8 #エンジランス
    add "movies" , changefreq: 'daily', priority: 0.8  #ムービーズ
    add "mail" , changefreq: 'daily', priority: 0.8  #メールマーケティング
    add "metal" , changefreq: 'daily', priority: 0.8  #金属加工
    add "marketing" , changefreq: 'daily', priority: 0.8  #デジタルマーケティング
    add "business" , changefreq: 'daily', priority: 0.8
    add "company" , changefreq: 'daily', priority: 0.8
    add "agent" , changefreq: 'daily', priority: 0.5
    add "recruit" , changefreq: 'daily', priority: 0.7
    add "recruit/parttime" , changefreq: 'daily', priority: 0.7
    add "recruit/regular" , changefreq: 'daily', priority: 0.7
    add "recruit/subcontracting" , changefreq: 'daily', priority: 0.7

    add "workers/new" , changefreq: 'daily', priority: 0.3

    # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
    add "/contact" , changefreq: 'daily', priority: 0.3

    add "recruits" , changefreq: 'daily', priority: 0.3



  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
   #Add '/posts'

     add posts_path, :priority => 0.7, :changefreq => 'daily'

  # Add all posts:

     Post.find_each do |post|
       add post_path(post), :lastmod => post.updated_at
     end
end

class Feeds
  def self.all
    # 86400 = 24 hours
    # 43200 = 12 hours
    # 21600 = 6 hours
    [
      { expiry: 86400, url: "https://blogs.dropbox.com/tech/feed/" },
      { expiry: 86400, url: "https://deliveroo.engineering/feed" },
      { expiry: 86400, url: "https://medium.com/feed/airbnb-engineering" },
      { expiry: 86400, url: "https://netflixtechblog.com/feed" },
      { expiry: 86400, url: "https://engineering.gusto.com/rss/" },
      { expiry: 86400, url: "https://www.docker.com/blog/category/engineering/feed/" },
      { expiry: 86400, url: "https://heap.io/blog/category/engineering/feed" },
      { expiry: 86400, url: "https://fivethirtyeight.com/tag/the-riddler/feed/" },
      { expiry: 86400, url: "https://slack.engineering/feed" },
      { expiry: 86400, url: "http://www.aaronsw.com/2002/feeds/pgessays.rss" },
      { expiry: 86400, url: "https://pudding.cool/feed/index.xml" },
      { expiry: 700,   url: "https://www.bilbof.com/feed.xml" },
      { expiry: 86400, url: "https://www.joelonsoftware.com/feed/" },
      { expiry: 86400, url: "https://tomnatt.blogspot.com/feeds/posts/default" },
      { expiry: 3600,  url: "http://calpaterson.com/calpaterson.rss" },
      { expiry: 700,   url: "https://engineering.shopify.com/blogs/engineering.atom" },
      { expiry: 700,   url: "https://eng.uber.com/feed/" },
      { expiry: 86400, url: "https://developers.soundcloud.com/blog/blog.rss" },
      { expiry: 700,   url: "https://gds.blog.gov.uk/feed/" },
      { expiry: 700,   url: "https://technology.blog.gov.uk/feed/" },
      { expiry: 86400, url: "http://rachelbythebay.com/w/atom.xml" },
      { expiry: 43200, url: "http://tenderlovemaking.com/atom.xml" },
      { expiry: 43200, url: "https://arogozhnikov.github.io/feed.xml" },
      { expiry: 86400, url: "https://hookrace.net/blog/feed/" },
      { expiry: 21600, url: "http://tholman.com/feed.xml" },
      { expiry: 21600, url: "http://brooker.co.za/blog/rss.xml" },
    ]
  end
end

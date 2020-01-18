require 'concurrent'
require './lib/feed'
require './lib/feeds'

class FeedCollection
  def self.feed_me
    promised_entries = Feeds.all.map { |feed| Feed.me(feed) }
    entries = Concurrent::Promises.zip(*promised_entries).value!
    entries.flatten.sort_by { |item| -item[:date].to_i }.first(20)
  end

  def self.refresh_cache
    promises = Feeds.all.map { |feed| Feed.me(feed, from_cache: false) }
    Concurrent::Promises.zip(*promises).value!
  end
end

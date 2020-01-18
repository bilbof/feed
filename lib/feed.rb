require 'concurrent'
require 'feedjira'
require 'httparty'
require 'loofah'
require "./lib/cache"

class Feed
  def self.me(feed, from_cache: true)
    Concurrent::Promises.future(feed[:url], feed[:expiry], from_cache) do |url, expiry, from_cache|
      self.fetch_from_url(url, expiry, from_cache)
    rescue => e
      []
    end
  end

private

  def self.fetch_from_url(url, expiry, from_cache)
    if from_cache
  		cached_entries = self.fetch_from_cache(url)
  		return cached_entries if cached_entries && cached_entries.any?
    end
    xml = HTTParty.get(url).body
    feed = Feedjira.parse(xml)
    entries = feed.entries.first(20).map do |item|
      date = item.published
      formatted_date = date ? item.published.strftime("%b %e, %Y") : "Unknown publication date"
      {
        title: sanitize(item.title),
        summary: truncate(sanitize(item.summary), truncate_at: 300),
        date: date,
        date_formatted: formatted_date,
        link: item.url,
        source: sanitize(feed.title),
      }
    end
    Cache.new.set(url, entries, expires_in: expiry)
    entries
  end

  def self.fetch_from_cache(url)
    Cache.new.get(url)
  rescue Cache::CacheError => e
    nil
  end

  def self.sanitize(value)
    Loofah.document(value).to_text(encode_special_chars: false)
  end

  def self.truncate(value, truncate_at: 0)
    return value unless value.length > truncate_at

    omission = "..."
    separator = " "
    length_with_room_for_omission = truncate_at - omission.length
    stop = value.rindex(separator, length_with_room_for_omission) || length_with_room_for_omission
    "#{value[0, stop]}#{omission}"
  end
end

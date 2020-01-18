#!/usr/bin/env ruby -I ../lib -I lib
require "dalli"
require "rack/cache"
require 'sinatra'
require "./lib/feed_collection"

class FeedApp < Sinatra::Application
  use Rack::Cache,
    metastore:    "memcached://localhost:11211/meta",
    entitystore:  "memcached://localhost:11211/body"

  before do
    expires 30, :public, :must_revalidate
  end

  get('/following') {
    erb :index, layout: :blog_layout, locals: { feed: { entries: FeedCollection.feed_me } }
  }

  get('/following.json') {
    [200, { feed: { entries: FeedCollection.feed_me } }.to_json]
  }
end
